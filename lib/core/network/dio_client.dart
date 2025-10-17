import 'package:dio/dio.dart';
import '../storage/prefs.dart';

class DioClient {
  DioClient({required String baseUrl, int timeoutMs = 10000}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: timeoutMs),
        receiveTimeout: Duration(milliseconds: timeoutMs),
        sendTimeout: Duration(milliseconds: timeoutMs),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Inject token from storage
          final auth = await Prefs.loadAuth();
          if (auth.token != null && auth.token!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${auth.token}';
          }
          handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (error, handler) {
          // Normalize errors similar to FE apiClient.ts
          handler.next(error);
        },
      ),
    );
  }

  late final Dio _dio;

  Dio get dio => _dio;
}
