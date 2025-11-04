import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:lms_mobile_flutter/features/auth/auth_state.dart';
import 'package:lms_mobile_flutter/features/auth/models/user_model.dart';
import 'package:lms_mobile_flutter/features/auth/services/auth_service.dart';
import 'package:lms_mobile_flutter/features/auth/services/token_manager.dart';
import 'package:lms_mobile_flutter/screens/shared/profile/profile_screen.dart';

class _SeededAuthNotifier extends AuthNotifier {
  _SeededAuthNotifier(UserModel user)
      : super(AuthService(Dio()), TokenManager()) {
    state = state.copyWith(
      user: user,
      accessToken: 'token',
      refreshToken: 'r',
      initialized: true,
    );
  }

  @override
  Future<void> updateUserProfile(UserModel updatedUser) async {
    // Skip persistence to token manager in tests
    state = state.copyWith(user: updatedUser);
  }
}

UserModel _makeUser() {
  return UserModel(
    id: 'u1',
    email: 'u1@example.com',
    username: 'u1',
    firstName: 'Test',
    lastName: 'User',
    role: UserRole.student,
    status: UserStatus.active,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<Uint8List?> fakePickAndCrop(BuildContext _) async {
    return Uint8List.fromList(List<int>.filled(10, 1));
  }

  testWidgets('avatar upload shows progress and success snackbar', (tester) async {
    final user = _makeUser();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => _SeededAuthNotifier(user)),
        ],
        child: const MaterialApp(
          home: SizedBox.shrink(),
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => _SeededAuthNotifier(user)),
        ],
        child: MaterialApp(
          home: ProfileScreen(
            debugPickAndCrop: fakePickAndCrop,
            debugUploadImpl: (ctx, bytes) async {
              await Future<void>.delayed(const Duration(milliseconds: 50));
              return true;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap avatar to start upload
    final avatar = find.byKey(const ValueKey('avatar_tap'));
    expect(avatar, findsOneWidget);
    await tester.tap(avatar);
    await tester.pump();

    // Progress overlay should appear
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    // Wait for upload to complete
    await tester.pump(const Duration(milliseconds: 200));

    // Success snackbar appears
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Cập nhật avatar thành công'), findsOneWidget);
  });

  testWidgets('avatar upload failure shows error snackbar', (tester) async {
    final user = _makeUser();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => _SeededAuthNotifier(user)),
        ],
        child: MaterialApp(
          home: ProfileScreen(
            debugPickAndCrop: fakePickAndCrop,
            debugUploadImpl: (ctx, bytes) async {
              await Future<void>.delayed(const Duration(milliseconds: 50));
              return false;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final avatar = find.byKey(const ValueKey('avatar_tap'));
    expect(avatar, findsOneWidget);
    await tester.tap(avatar);
    await tester.pump();

    // Progress overlay visible
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await tester.pump(const Duration(milliseconds: 200));

    // Error snackbar appears
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Tải lên avatar thất bại'), findsOneWidget);
  });
}
