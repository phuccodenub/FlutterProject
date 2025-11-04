import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import '../services/logger_service.dart';

enum NetworkStatus { online, offline, unknown }

class ConnectivityState {
  const ConnectivityState({
    this.status = NetworkStatus.unknown,
    this.hasError = false,
    this.errorMessage,
  });

  final NetworkStatus status;
  final bool hasError;
  final String? errorMessage;

  bool get isOnline => status == NetworkStatus.online;
  bool get isOffline => status == NetworkStatus.offline;

  ConnectivityState copyWith({
    NetworkStatus? status,
    bool? hasError,
    String? errorMessage,
  }) {
    return ConnectivityState(
      status: status ?? this.status,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ConnectivityNotifier extends StateNotifier<ConnectivityState> {
  ConnectivityNotifier() : super(const ConnectivityState()) {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  void _init() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);

    // Listen to connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final isConnected = results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );

    state = state.copyWith(
      status: isConnected ? NetworkStatus.online : NetworkStatus.offline,
    );
  }

  void setError(String message) {
    state = state.copyWith(hasError: true, errorMessage: message);
  }

  void clearError() {
    state = state.copyWith(hasError: false, errorMessage: null);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectivityState>(
      (ref) => ConnectivityNotifier(),
    );

// Timeout wrapper for API calls
class ApiTimeout {
  static const defaultTimeout = Duration(seconds: 30);

  static Future<T> wrap<T>(
    Future<T> future, {
    Duration? timeout,
    String? timeoutMessage,
  }) async {
    try {
      return await future.timeout(
        timeout ?? defaultTimeout,
        onTimeout: () {
          throw TimeoutException(timeoutMessage ?? 'Request timed out');
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}

class TimeoutException implements Exception {
  TimeoutException(this.message);
  final String message;

  @override
  String toString() => message;
}

// Error handler utility
class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is TimeoutException) {
      return 'Request timed out. Please check your connection and try again.';
    }

    if (error is NetworkStatus && error == NetworkStatus.offline) {
      return 'No internet connection. Please check your network settings.';
    }

    if (error.toString().contains('SocketException')) {
      return 'Cannot connect to server. Please try again later.';
    }

    if (error.toString().contains('FormatException')) {
      return 'Invalid data received. Please try again.';
    }

    return 'An unexpected error occurred: ${error.toString()}';
  }

  static void showError(String message, {VoidCallback? onRetry}) {
    // This will be shown via overlay or snackbar
    logger.error('Network error occurred', {
      'message': message,
      'hasRetry': onRetry != null,
    });
  }
}
