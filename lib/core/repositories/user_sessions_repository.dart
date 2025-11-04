import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_session.dart';
import '../config/api_config.dart';
import '../network/dio_provider.dart';

abstract class UserSessionsRepository {
  Future<List<UserSession>> getSessions();
  Future<void> terminateSession(String sessionId);
}

class UserSessionsRepositoryImpl implements UserSessionsRepository {
  final Dio _dio;
  UserSessionsRepositoryImpl(this._dio);

  @override
  Future<List<UserSession>> getSessions() async {
    final response = await _dio.get(ApiConfig.userSessions);
    final data = response.data;
    List<UserSession> sessions = const [];
    if (data is Map && data['data'] is List) {
      sessions = (data['data'] as List)
          .map((e) => UserSession.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (data is List) {
      sessions = data
          .map((e) => UserSession.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return sessions;
  }

  @override
  Future<void> terminateSession(String sessionId) async {
    await _dio.delete('${ApiConfig.userSessions}/$sessionId');
  }
}

final userSessionsRepositoryProvider = Provider<UserSessionsRepository>((ref) {
  final dio = ref.read(dioProvider);
  return UserSessionsRepositoryImpl(dio);
});
