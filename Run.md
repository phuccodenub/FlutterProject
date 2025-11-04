# 🚀 Hướng Dẫn Chạy Flutter LMS App

## 📋 Tổng Quan
Flutter LMS App kết nối với backend Node.js/Express và database PostgreSQL. Có 2 cách để chạy ứng dụng:

---

## 🐳 **PHƯƠNG PHÁP 1: Docker Compose + Flutter Run (Khuyên Dùng)**

### 🔧 **Yêu Cầu Hệ Thống**
- Flutter SDK (3.x+)
- Docker Desktop
- Android Studio/Emulator hoặc iOS Simulator
- Git

### 📂 **Cấu Trúc Dự Án**
```
Project/
├── lms_mobile_flutter/     # Flutter app
└── backend/               # Node.js backend
    └── docker/           # Docker compose files
```

### 🚀 **Các Bước Thực Hiện**

#### **Bước 1: Khởi Động Backend Services với Docker**
```powershell
# Di chuyển đến thư mục backend
cd h:\DACN\backend

# Khởi động tất cả services (Backend + PostgreSQL + Redis)
docker compose -f docker/docker-compose.dev.yml up -d

# Kiểm tra trạng thái services
docker compose ps
```

**Services sẽ chạy:**
- `dacn-backend-1`: Node.js API (Port 3000)
- `dacn-postgres-1`: PostgreSQL Database (Port 5432)  
- `dacn-redis-1`: Redis Cache (Port 6379)
- `dacn-frontend-1`: Frontend (Port 8080)

#### **Bước 2: Kiểm Tra Backend Health**
```powershell
# Test API endpoint
curl http://localhost:3000/api/health

# Hoặc mở browser: http://localhost:3000/api/health
```

#### **Bước 3: Seed Database với Test Users**
```powershell
# Vào container backend
docker exec -it dacn-backend-1 bash

# Chạy script seed users
npm run seed:users

# Hoặc chạy trực tiếp từ host
docker exec dacn-backend-1 npm run seed:users
```

**Test Users được tạo:**
- **Super Admin:** `superadmin@example.com` / `SuperAdmin123!`
- **Admin:** `admin@example.com` / `Admin123!`
- **Instructor:** `instructor1@example.com` / `Instructor123!` 
- **Student:** `student1@example.com` / `Student123!`

**Note:** Flutter app Quick Login buttons đã được cập nhật với credentials đúng.

#### **Bước 4: Khởi Động Android Emulator**
```powershell
# Liệt kê emulators có sẵn
flutter emulators

# Khởi động emulator
flutter emulators --launch flutter_emulator

# Kiểm tra devices
flutter devices
```

#### **Bước 5: Chạy Flutter App**
```powershell
# Di chuyển đến Flutter project
cd c:\Project\lms_mobile_flutter

# Get dependencies
flutter pub get

# Chạy app trên emulator
flutter run -d emulator-5554

# Hoặc chỉ định device cụ thể
flutter run
```

### 🔍 **Xác Minh Kết Nối**
- Flutter app sẽ kết nối tới backend qua: `http://10.0.2.2:3000`
- Test authentication với 3 tài khoản ở trên
- Kiểm tra console logs để debug

---

## ⚙️ **PHƯƠNG PHÁP 2: Chạy Thủ Công (Manual Setup)**

### 🔧 **Yêu Cầu Bổ Sung**
- Node.js (18+)
- PostgreSQL (15+) 
- Redis Server
- npm hoặc yarn

### 📦 **Cài Đặt Dependencies**

#### **Backend Setup:**
```powershell
cd h:\DACN\backend

# Cài đặt dependencies
npm install

# Copy environment file
cp env.example .env

# Chỉnh sửa .env với thông tin database của bạn
# DATABASE_URL=postgresql://username:password@localhost:5432/lms_db
# REDIS_URL=redis://localhost:6379
```

#### **Database Setup:**
```powershell
# Khởi động PostgreSQL service
# Windows: Services.msc → PostgreSQL

# Tạo database
createdb lms_db

# Hoặc qua psql
psql -U postgres -c "CREATE DATABASE lms_db;"

# Chạy migrations
npm run migrate

# Seed test data
npm run seed:users
```

#### **Redis Setup:**
```powershell
# Windows: Cài Redis từ Microsoft Store
# Hoặc sử dụng Redis for Windows

# Khởi động Redis server
redis-server
```

### 🚀 **Khởi Động Services**

#### **Terminal 1: Backend API**
```powershell
cd h:\DACN\backend

# Development mode với hot reload
npm run dev

# Hoặc production mode
npm run build
npm start
```

#### **Terminal 2: Flutter App**
```powershell
cd c:\Project\lms_mobile_flutter

# Get dependencies nếu chưa
flutter pub get

# Chạy app
flutter run
```

### 🔧 **Cấu Hình Network**
Chỉnh sửa Flutter app config để trỏ đến localhost:

```dart
// lib/core/config/api_config.dart
static const String baseUrl = 'http://10.0.2.2:3000'; // Emulator
// static const String baseUrl = 'http://localhost:3000'; // iOS Simulator
```

---

## 🛠️ **Troubleshooting**

### ❌ **Lỗi Thường Gặp**

#### **1. Docker Issues:**
```powershell
# IMPORTANT: Port conflicts thường xảy ra khi có nhiều compose files
# Kiểm tra containers đang chạy
docker ps -a

# Dừng tất cả containers cũ
docker stop $(docker ps -q)

# Method 1: Sử dụng docker-compose.yml (Full stack - Backend + DB)
docker compose -f docker/docker-compose.yml down
docker compose -f docker/docker-compose.yml up -d --build

# Method 2: Chỉ Database services (Dev mode)  
docker compose -f docker/docker-compose.dev.yml down
docker compose -f docker/docker-compose.dev.yml up -d

# Xem logs
docker compose logs lms_backend

# Fix port conflicts
netstat -ano | findstr :6379  # Check Redis port
netstat -ano | findstr :5432  # Check PostgreSQL port
```

#### **2. Flutter Build Issues:**
```powershell
# Clean và rebuild
flutter clean
flutter pub get
flutter run
```

#### **3. Network Connectivity:**
- **Android Emulator:** Sử dụng `10.0.2.2:3000`
- **iOS Simulator:** Sử dụng `localhost:3000`
- **Physical Device:** Sử dụng IP của máy host

#### **4. Authentication Issues:**
```powershell
# Reset passwords trong database
docker exec -it dacn-postgres-1 psql -U postgres -d lms_db -f /app/fix-passwords.sql
```

### 🔍 **Debug Commands:**
```powershell
# Kiểm tra backend health
curl http://localhost:3000/api/health

# Kiểm tra database connection
docker exec dacn-postgres-1 psql -U postgres -c "\l"

# Xem Flutter logs chi tiết  
flutter run --verbose

# Kiểm tra network từ emulator
adb shell ping 10.0.2.2
```

---

## 📱 **Testing Authentication**

### 🔐 **Test Accounts:**
1. **Admin Account:**
   - Email: `admin@example.com`
   - Password: `Admin123!`
   - Role: Administrator

2. **Instructor Account:**
   - Email: `instructor@example.com` 
   - Password: `Instructor123!`
   - Role: Teacher

3. **Student Account:**
   - Email: `student11@example.com`
   - Password: `Student123!`
   - Role: Student

### ✅ **Testing Flow:**
1. Mở Flutter app
2. Sử dụng Quick Login buttons hoặc nhập thủ công
3. Xác minh dashboard theo role
4. Test logout functionality

---

## 📞 **Hỗ Trợ**

### 🚨 **Khi Gặp Vấn Đề:**
1. Kiểm tra Docker services: `docker compose ps`
2. Xem logs: `docker compose logs`
3. Restart services: `docker compose restart`
4. Kiểm tra Flutter devices: `flutter devices`
5. Clean Flutter cache: `flutter clean`

### 📊 **Monitoring:**
- Backend API: http://localhost:3000/api/health
- Database: Kết nối qua pgAdmin hoặc psql
- Redis: Sử dụng redis-cli hoặc RedisInsight

---

**🎯 Khuyến nghị sử dụng PHƯƠNG PHÁP 1 (Docker) để đảm bảo môi trường nhất quán và dễ setup!**