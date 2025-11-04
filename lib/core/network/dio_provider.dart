import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_client.dart';

/// Global Dio provider to enable dependency injection and test overrides.
final dioProvider = Provider<Dio>((ref) => DioClient().dio);
