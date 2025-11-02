import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Performance optimization utilities for animations
class AnimationPerformance {
  static const int targetFPS = 60;
  static const double frameTime = 1000 / targetFPS; // 16.67ms per frame

  /// Check if animations should be enabled based on performance
  static bool get shouldEnableAnimations {
    return !_isLowEndDevice() && !_isReduceAnimationsEnabled();
  }

  /// Check if device is low-end
  static bool _isLowEndDevice() {
    // This is a simplified check - in real app, you'd check device specs
    return false; // For demo purposes
  }

  /// Check if system reduce animations is enabled
  static bool _isReduceAnimationsEnabled() {
    return MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.first
    ).disableAnimations;
  }

  /// Create optimized animation controller
  static AnimationController createOptimizedController({
    required Duration duration,
    required TickerProvider vsync,
    Duration? reverseDuration,
    String? debugLabel,
  }) {
    return AnimationController(
      duration: shouldEnableAnimations ? duration : const Duration(milliseconds: 1),
      reverseDuration: reverseDuration,
      vsync: vsync,
      debugLabel: debugLabel,
    );
  }
}

/// Widget that automatically wraps expensive animations with RepaintBoundary
class OptimizedAnimationWidget extends StatelessWidget {
  final Widget child;
  final bool forceRepaintBoundary;

  const OptimizedAnimationWidget({
    super.key,
    required this.child,
    this.forceRepaintBoundary = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!AnimationPerformance.shouldEnableAnimations) {
      return child;
    }

    if (forceRepaintBoundary) {
      return RepaintBoundary(child: child);
    }

    return child;
  }
}

/// Mixin for automatic animation controller disposal
mixin AnimationDisposalMixin<T extends StatefulWidget> on State<T> {
  final List<AnimationController> _controllers = [];

  /// Register animation controller for automatic disposal
  void registerAnimationController(AnimationController controller) {
    _controllers.add(controller);
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      if (controller.isAnimating) {
        controller.stop();
      }
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }
}

/// Performance monitor for animations
class AnimationPerformanceMonitor {
  static final AnimationPerformanceMonitor _instance = AnimationPerformanceMonitor._internal();
  factory AnimationPerformanceMonitor() => _instance;
  AnimationPerformanceMonitor._internal();

  final List<double> _frameTimes = [];
  int _droppedFrames = 0;
  int _totalFrames = 0;

  void startMonitoring() {
    SchedulerBinding.instance.addPersistentFrameCallback(_onFrame);
  }

  void stopMonitoring() {
    // Note: There's no removePersistentFrameCallback in Flutter
    // Monitoring will automatically stop when app is disposed
  }

  void _onFrame(Duration timestamp) {
    _totalFrames++;
    final frameTime = timestamp.inMicroseconds / 1000.0; // Convert to milliseconds

    _frameTimes.add(frameTime);
    if (_frameTimes.length > 120) { // Keep last 2 seconds of frames
      _frameTimes.removeAt(0);
    }

    // Detect dropped frames (frame took longer than expected)
    if (frameTime > AnimationPerformance.frameTime * 1.5) {
      _droppedFrames++;
    }
  }

  /// Get average frame time
  double get averageFrameTime {
    if (_frameTimes.isEmpty) return 0;
    return _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
  }

  /// Get FPS
  double get fps {
    return averageFrameTime > 0 ? 1000 / averageFrameTime : 0;
  }

  /// Get dropped frame percentage
  double get droppedFramePercentage {
    return _totalFrames > 0 ? (_droppedFrames / _totalFrames) * 100 : 0;
  }

  /// Reset statistics
  void reset() {
    _frameTimes.clear();
    _droppedFrames = 0;
    _totalFrames = 0;
  }
}

/// Widget that preloads animations to reduce first-time jank
class AnimationPreloader extends StatefulWidget {
  final List<Widget Function()> animationBuilders;
  final Widget child;
  final Duration preloadDuration;

  const AnimationPreloader({
    super.key,
    required this.animationBuilders,
    required this.child,
    this.preloadDuration = const Duration(milliseconds: 100),
  });

  @override
  State<AnimationPreloader> createState() => _AnimationPreloaderState();
}

class _AnimationPreloaderState extends State<AnimationPreloader> {
  bool _isPreloaded = false;

  @override
  void initState() {
    super.initState();
    _preloadAnimations();
  }

  Future<void> _preloadAnimations() async {
    // Simplified preloading - just build widgets once to compile shaders
    for (final builder in widget.animationBuilders) {
      // Build widget to trigger shader compilation
      builder();
    }

    await Future.delayed(widget.preloadDuration);
    
    if (mounted) {
      setState(() {
        _isPreloaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPreloaded) {
      // Show loading indicator while preloading
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return widget.child;
  }
}

/// Adaptive animation duration based on device performance
class AdaptiveAnimation {
  static Duration getDuration(Duration baseDuration) {
    if (!AnimationPerformance.shouldEnableAnimations) {
      return const Duration(milliseconds: 1);
    }

    final monitor = AnimationPerformanceMonitor();
    final fps = monitor.fps;

    if (fps < 30) {
      // Reduce animation duration for poor performance
      return Duration(milliseconds: (baseDuration.inMilliseconds * 0.5).round());
    } else if (fps < 45) {
      // Slightly reduce duration
      return Duration(milliseconds: (baseDuration.inMilliseconds * 0.75).round());
    }

    return baseDuration;
  }

  static Curve getCurve(Curve baseCurve) {
    if (!AnimationPerformance.shouldEnableAnimations) {
      return Curves.linear;
    }

    final monitor = AnimationPerformanceMonitor();
    final fps = monitor.fps;

    if (fps < 30) {
      // Use simpler curves for poor performance
      return Curves.easeInOut;
    }

    return baseCurve;
  }
}

/// Widget that reduces animation complexity based on performance
class PerformanceAwareWidget extends StatelessWidget {
  final Widget highPerformanceChild;
  final Widget? lowPerformanceChild;
  final double performanceThreshold;

  const PerformanceAwareWidget({
    super.key,
    required this.highPerformanceChild,
    this.lowPerformanceChild,
    this.performanceThreshold = 45.0, // FPS threshold
  });

  @override
  Widget build(BuildContext context) {
    final monitor = AnimationPerformanceMonitor();
    final fps = monitor.fps;

    if (fps < performanceThreshold && lowPerformanceChild != null) {
      return lowPerformanceChild!;
    }

    return highPerformanceChild;
  }
}

/// Batch animation controller for managing multiple animations efficiently
class BatchAnimationController {
  final List<AnimationController> _controllers = [];
  final TickerProvider _vsync;

  BatchAnimationController(this._vsync);

  AnimationController createController({
    required Duration duration,
    Duration? reverseDuration,
    String? debugLabel,
  }) {
    final controller = AnimationPerformance.createOptimizedController(
      duration: duration,
      vsync: _vsync,
      reverseDuration: reverseDuration,
      debugLabel: debugLabel,
    );
    _controllers.add(controller);
    return controller;
  }

  /// Start all animations
  void forwardAll() {
    for (final controller in _controllers) {
      controller.forward();
    }
  }

  /// Reverse all animations
  void reverseAll() {
    for (final controller in _controllers) {
      controller.reverse();
    }
  }

  /// Stop all animations
  void stopAll() {
    for (final controller in _controllers) {
      if (controller.isAnimating) {
        controller.stop();
      }
    }
  }

  /// Reset all animations
  void resetAll() {
    for (final controller in _controllers) {
      controller.reset();
    }
  }

  /// Dispose all controllers
  void dispose() {
    stopAll();
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
  }
}

/// Extension for optimized animations
extension OptimizedAnimationController on AnimationController {
  /// Create an optimized curved animation
  CurvedAnimation createOptimizedCurve(Curve curve) {
    return CurvedAnimation(
      parent: this,
      curve: AdaptiveAnimation.getCurve(curve),
    );
  }
}

/// Utility for managing animation preloading
class AnimationCache {
  static final AnimationCache _instance = AnimationCache._internal();
  factory AnimationCache() => _instance;
  AnimationCache._internal();

  final Map<String, Widget> _cachedWidgets = {};
  final Set<String> _preloadedAnimations = {};

  /// Cache a widget for later use
  void cacheWidget(String key, Widget widget) {
    _cachedWidgets[key] = widget;
  }

  /// Get cached widget
  Widget? getCachedWidget(String key) {
    return _cachedWidgets[key];
  }

  /// Mark animation as preloaded
  void markAsPreloaded(String animationKey) {
    _preloadedAnimations.add(animationKey);
  }

  /// Check if animation is preloaded
  bool isPreloaded(String animationKey) {
    return _preloadedAnimations.contains(animationKey);
  }

  /// Clear cache
  void clearCache() {
    _cachedWidgets.clear();
    _preloadedAnimations.clear();
  }
}