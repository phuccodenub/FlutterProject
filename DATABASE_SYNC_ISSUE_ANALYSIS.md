# 🔍 PHÂN TÍCH VẤN ĐỀ LOGIN SAU KHI THAY ĐỔI DB.SYNC

## 🎯 ROOT CAUSE

**Thay đổi trong `db.ts`:**
```typescript
// Cũ: await db.sync({ alter: true });
// Mới: await db.sync({ force: false });
```

**Impact:**
- `alter: true` - Sequelize sẽ ALTER TABLE để sync schema với model, giữ lại data
- `force: false` - Sequelize chỉ tạo tables nếu chưa tồn tại, KHÔNG thay đổi schema đã có

**Vấn đề:**
Khi chuyển từ `alter: true` sang `force: false`:
1. ✅ Database schema không được sync với model changes
2. ✅ Passwords trong database có thể đã bị mất hoặc không đúng format
3. ✅ Users có thể không tồn tại hoặc passwords đã bị corrupted

## 🔍 PHÂN TÍCH BACKEND LOGIN FLOW

### 1. Backend Login Process (auth.service.ts:76-175)

```typescript
// 1. Find user by email
const user = await this.authRepository.findUserForAuth(credentials.email);
if (!user) {
  throw ApiError.unauthorized('Invalid credentials');
}

// 2. Compare password
const isPasswordValid = await globalServices.auth.comparePassword(
  credentials.password, 
  user.password_hash
);

if (!isPasswordValid) {
  throw ApiError.unauthorized('Invalid credentials');
}
```

### 2. Password Hash Process

**Seeder sử dụng:**
```typescript
password: await hashUtils.password.hashPassword('Admin123!')
```

**Stored in database column:** `password` (mapped to `password_hash` in model)

**Login compares:** `credentials.password` vs `user.password_hash`

## 🚨 CÁC NGUYÊN NHÂN CÓ THỂ

### 1. **Users không tồn tại trong database**
- Khi chuyển từ `alter: true` sang `force: false`, users có thể đã bị mất
- Cần chạy lại seeders để tạo users

### 2. **Password column name mismatch**
- Model map `password_hash` → `password` column
- Có thể column name không đúng hoặc không tồn tại

### 3. **Password hash format không đúng**
- Hash algorithm có thể đã thay đổi
- Old passwords không match với new hash format

### 4. **Database schema không sync**
- Model expect một số columns nhưng database không có
- Sequelize không thể query đúng

## ✅ GIẢI PHÁP

### Giải pháp 1: Re-seed Database (KHuyên dùng)

**Chạy lại seeders để tạo users với passwords đúng:**

```powershell
# Nếu dùng Docker
docker exec -it dacn-backend-1 npm run seed:users

# Hoặc chạy trực tiếp
cd H:\DACN\backend
npm run seed:users
```

**Hoặc chạy full seed:**
```powershell
npm run seed:database
```

### Giải pháp 2: Kiểm tra Database

**Kiểm tra users có tồn tại không:**
```sql
SELECT id, email, password, role, status 
FROM users 
WHERE email IN (
  'admin@example.com',
  'instructor1@example.com', 
  'student1@example.com'
);
```

**Kiểm tra password column:**
```sql
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'users' 
AND column_name LIKE '%password%';
```

### Giải pháp 3: Fix Database Schema

**Nếu cần sync schema, có thể tạm thời dùng:**
```typescript
// Trong db.ts, tạm thời dùng:
await db.sync({ alter: true }); // Sync schema và giữ data
```

**Sau đó chuyển lại:**
```typescript
await db.sync({ force: false }); // Production mode
```

**Và re-seed users:**
```powershell
npm run seed:users
```

### Giải pháp 4: Verify Password Hash Function

**Kiểm tra hash function có đúng không:**
```typescript
// Test trong backend
import { hashUtils } from './utils/hash.util';
import { globalServices } from './services/global';

const password = 'Admin123!';
const hash = await hashUtils.password.hashPassword(password);
const isValid = await globalServices.auth.comparePassword(password, hash);

console.log('Hash:', hash);
console.log('Is Valid:', isValid); // Should be true
```

## 🧪 TESTING STEPS

### 1. Verify Database Connection
```sql
-- Connect to database
\c lms_db

-- Check users table exists
SELECT * FROM users LIMIT 5;
```

### 2. Check Users Exist
```sql
SELECT email, role, status, 
       LENGTH(password) as password_length,
       LEFT(password, 20) as password_preview
FROM users 
WHERE email IN ('admin@example.com', 'instructor1@example.com', 'student1@example.com');
```

### 3. Test Login via API
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"Admin123!"}'
```

### 4. Check Backend Logs
```powershell
# Docker logs
docker logs dacn-backend-1 --tail 100

# Hoặc check console output
```

## 📝 ACTION ITEMS

1. ✅ **Immediate:** Re-seed database users
   ```powershell
   cd H:\DACN\backend
   npm run seed:users
   ```

2. ✅ **Verify:** Check users exist in database
   ```sql
   SELECT email, role FROM users WHERE email LIKE '%@example.com';
   ```

3. ✅ **Test:** Try login again with credentials
   - `admin@example.com` / `Admin123!`
   - `instructor1@example.com` / `Instructor123!`
   - `student1@example.com` / `Student123!`

4. ✅ **If still fails:** Check backend logs for password comparison errors

## 🔧 QUICK FIX COMMAND

```powershell
# Stop backend
docker compose -f docker/docker-compose.dev.yml stop backend

# Re-seed database
docker exec dacn-postgres-1 psql -U postgres -d lms_db -c "TRUNCATE TABLE users CASCADE;"
docker exec dacn-backend-1 npm run seed:users

# Restart backend
docker compose -f docker/docker-compose.dev.yml start backend

# Test login
curl -X POST http://localhost:3000/api/v1/auth/login -H "Content-Type: application/json" -d '{"email":"admin@example.com","password":"Admin123!"}'
```

## 📊 EXPECTED RESULTS

Sau khi re-seed, bạn sẽ thấy:
- ✅ Users được tạo với passwords đã hash đúng
- ✅ Login API trả về `200` với `success: true`
- ✅ Response có `user` và `tokens` objects
- ✅ Flutter app có thể login thành công

