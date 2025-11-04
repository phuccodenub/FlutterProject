import 'package:dio/dio.dart';
import '../network/api_client.dart';

/// Base repository providing common API operation patterns
/// All feature repositories should extend this class for consistent API handling
abstract class BaseRepository {
  final Dio _dio;

  BaseRepository(this._dio);

  /// Generic GET request
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (error) {
      throw _handleError(error);
    }
  }

  /// Generic POST request
  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (error) {
      throw _handleError(error);
    }
  }

  /// Generic PUT request
  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (error) {
      throw _handleError(error);
    }
  }

  /// Generic PATCH request
  Future<T> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (error) {
      throw _handleError(error);
    }
  }

  /// Generic DELETE request
  Future<T> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (error) {
      throw _handleError(error);
    }
  }

  /// Upload file with progress tracking
  Future<T> uploadFile<T>(
    String endpoint, {
    required FormData formData,
    void Function(int, int)? onSendProgress,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (error) {
      throw _handleError(error);
    }
  }

  /// Download file with progress tracking
  Future<void> downloadFile(
    String endpoint,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _dio.download(
        endpoint,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
    } catch (error) {
      throw _handleError(error);
    }
  }

  /// Get paginated results
  Future<PaginatedResponse<T>> getPaginated<T>(
    String endpoint, {
    int page = 1,
    int limit = 20,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final params = {'page': page, 'limit': limit, ...?queryParameters};

      final response = await _dio.get(
        endpoint,
        queryParameters: params,
        options: options,
      );

      return _handlePaginatedResponse<T>(response, fromJson);
    } catch (error) {
      throw _handleError(error);
    }
  }

  /// Handle successful response
  T _handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    // Check if response has success field in body (even with 200 status)
    if (data is Map<String, dynamic>) {
      final success = data['success'] as bool?;
      
      // If success is explicitly false, throw exception with proper message
      if (success == false) {
        final message = data['message'] as String? ?? 
                       data['error'] as String? ?? 
                       'Request failed';
        throw RepositoryException(
          message: message,
          statusCode: statusCode == 200 ? 400 : statusCode, // Treat 200 with success=false as 400
          details: data,
        );
      }
    }

    // Only accept 200/201 for successful responses
    if (statusCode == 200 || statusCode == 201) {
      if (data is Map<String, dynamic>) {
        // If response has nested data structure
        if (data.containsKey('data')) {
          if (fromJson != null) {
            return fromJson(data['data'] as Map<String, dynamic>);
          }
          return data['data'] as T;
        }

        // Direct data
        if (fromJson != null) {
          return fromJson(data);
        }
        return data as T;
      }

      return data as T;
    } else {
      // Extract error message from response body if available
      String errorMessage = 'Unexpected status code: $statusCode';
      if (data is Map<String, dynamic>) {
        errorMessage = data['message'] as String? ?? 
                      data['error'] as String? ?? 
                      errorMessage;
      }
      
      throw RepositoryException(
        message: errorMessage,
        statusCode: statusCode,
        details: data is Map<String, dynamic> ? data : null,
      );
    }
  }

  /// Handle paginated response
  PaginatedResponse<T> _handlePaginatedResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final responseData = data['data'] as Map<String, dynamic>;

      final items = (responseData['items'] as List)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();

      return PaginatedResponse<T>(
        items: items,
        totalItems: responseData['totalItems'] as int? ?? items.length,
        totalPages: responseData['totalPages'] as int? ?? 1,
        currentPage: responseData['currentPage'] as int? ?? 1,
        itemsPerPage: responseData['itemsPerPage'] as int? ?? items.length,
        hasNextPage: responseData['hasNextPage'] as bool? ?? false,
        hasPreviousPage: responseData['hasPreviousPage'] as bool? ?? false,
      );
    } else {
      throw RepositoryException(
        message: 'Failed to fetch paginated data',
        statusCode: response.statusCode,
      );
    }
  }

  /// Handle API errors
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.error is ApiError) {
        final apiError = error.error as ApiError;
        return RepositoryException(
          message: apiError.message,
          statusCode: apiError.statusCode,
          type: apiError.type,
          details: apiError.details,
        );
      }

      return RepositoryException(
        message: error.message ?? 'Network error occurred',
        statusCode: error.response?.statusCode,
      );
    }

    return RepositoryException(message: error.toString(), statusCode: null);
  }
}

/// Repository-specific exception
class RepositoryException implements Exception {
  final String message;
  final int? statusCode;
  final ApiErrorType? type;
  final Map<String, dynamic>? details;

  RepositoryException({
    required this.message,
    this.statusCode,
    this.type,
    this.details,
  });

  @override
  String toString() => 'RepositoryException: $message';
}

/// Paginated response wrapper
class PaginatedResponse<T> {
  final List<T> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedResponse({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// Check if there are more items to load
  bool get hasMore => hasNextPage;

  /// Get next page number
  int? get nextPage => hasNextPage ? currentPage + 1 : null;

  /// Get previous page number
  int? get previousPage => hasPreviousPage ? currentPage - 1 : null;
}

/// API response wrapper for consistent data structure
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? meta;
  final List<String>? errors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.meta,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJson != null
          ? fromJson(json['data'] as Map<String, dynamic>)
          : json['data'] as T?,
      meta: json['meta'] as Map<String, dynamic>?,
      errors: json['errors'] != null
          ? List<String>.from(json['errors'] as List)
          : null,
    );
  }
}
