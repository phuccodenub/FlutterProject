import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../animations/app_animations.dart';

class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;
  final double displacement;
  final EdgeInsets edgeOffset;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.displacement = 40.0,
    this.edgeOffset = EdgeInsets.zero,
  });

  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _scaleController;
  late AnimationController _bounceController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isRefreshing = false;
  double _dragOffset = 0.0;
  static const double _maxDragDistance = 120.0;
  static const double _triggerDistance = 80.0;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );



    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.bounceOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.grey,
      end: widget.color ?? Theme.of(context).primaryColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isRefreshing) return;

    setState(() {
      _dragOffset = (_dragOffset + details.delta.dy).clamp(0.0, _maxDragDistance);
    });

    final progress = _dragOffset / _maxDragDistance;
    _controller.value = progress;
    _scaleController.value = progress;

    // Haptic feedback at trigger point
    if (_dragOffset >= _triggerDistance && (_dragOffset - details.delta.dy) < _triggerDistance) {
      HapticFeedback.mediumImpact();
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isRefreshing) return;

    if (_dragOffset >= _triggerDistance) {
      _triggerRefresh();
    } else {
      _resetPosition();
    }
  }

  void _triggerRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Trigger haptic feedback
    HapticFeedback.heavyImpact();
    
    // Animate to final position
    await _controller.forward();
    _bounceController.forward();

    try {
      await widget.onRefresh();
    } finally {
      await Future.delayed(const Duration(milliseconds: 500));
      _resetPosition();
    }
  }

  void _resetPosition() async {
    _bounceController.reverse();
    await _controller.reverse();
    await _scaleController.reverse();
    
    setState(() {
      _isRefreshing = false;
      _dragOffset = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Refresh indicator
        Positioned(
          top: widget.edgeOffset.top + widget.displacement - 60,
          left: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: Listenable.merge([_controller, _scaleController, _bounceController]),
            builder: (context, child) {
              if (_dragOffset == 0.0 && !_isRefreshing) {
                return const SizedBox.shrink();
              }

              return Transform.translate(
                offset: Offset(0, _dragOffset * 0.6),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ?? Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: _isRefreshing
                          ? Transform.scale(
                              scale: 0.8 + (_bounceAnimation.value * 0.2),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _colorAnimation.value ?? Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : CustomRefreshIcon(
                              progress: _controller.value,
                              color: _colorAnimation.value ?? Theme.of(context).primaryColor,
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        // Main content
        GestureDetector(
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: widget.child,
        ),
      ],
    );
  }
}

class CustomRefreshIcon extends StatelessWidget {
  final double progress;
  final Color color;

  const CustomRefreshIcon({
    super.key,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: progress * 6.28, // Full rotation
      child: Icon(
        Icons.refresh,
        color: color.withValues(alpha: 0.3 + (progress * 0.7)),
        size: 20,
      ),
    );
  }
}

class ElasticRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final String? refreshText;
  final String? releaseText;
  final String? loadingText;

  const ElasticRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.refreshText = 'Kéo để làm mới',
    this.releaseText = 'Thả để làm mới',
    this.loadingText = 'Đang tải...',
  });

  @override
  State<ElasticRefreshIndicator> createState() => _ElasticRefreshIndicatorState();
}

class _ElasticRefreshIndicatorState extends State<ElasticRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _elasticController;
  late Animation<double> _elasticAnimation;
  
  bool _isRefreshing = false;
  double _pullDistance = 0.0;
  static const double _maxPullDistance = 150.0;
  static const double _triggerDistance = 100.0;

  @override
  void initState() {
    super.initState();
    
    _elasticController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _elasticAnimation = CurvedAnimation(
      parent: _elasticController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _elasticController.dispose();
    super.dispose();
  }

  String get _currentText {
    if (_isRefreshing) return widget.loadingText!;
    if (_pullDistance >= _triggerDistance) return widget.releaseText!;
    return widget.refreshText!;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isRefreshing = true;
        });
        
        HapticFeedback.heavyImpact();
        _elasticController.forward().then((_) {
          _elasticController.reverse();
        });

        try {
          await widget.onRefresh();
        } finally {
          setState(() {
            _isRefreshing = false;
            _pullDistance = 0.0;
          });
        }
      },
      color: widget.color ?? Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      displacement: 60,
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels < 0) {
            setState(() {
              _pullDistance = (-notification.metrics.pixels).clamp(0.0, _maxPullDistance);
            });
            
            if (_pullDistance >= _triggerDistance && 
                (_pullDistance - 10) < _triggerDistance) {
              HapticFeedback.mediumImpact();
            }
          }
          return false;
        },
        child: Stack(
          children: [
            widget.child,
            
            // Custom header
            if (_pullDistance > 0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _elasticAnimation,
                  builder: (context, child) {
                    final elasticOffset = _elasticAnimation.value * 20;
                    
                    return Transform.translate(
                      offset: Offset(0, -60 + (_pullDistance * 0.5) + elasticOffset),
                      child: SizedBox(
                        height: 60,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isRefreshing)
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      widget.color ?? Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                              else
                                Transform.rotate(
                                  angle: (_pullDistance / _maxPullDistance) * 6.28,
                                  child: Icon(
                                    Icons.refresh,
                                    color: (widget.color ?? Theme.of(context).primaryColor)
                                        .withValues(alpha: 0.3 + (_pullDistance / _maxPullDistance) * 0.7),
                                    size: 20,
                                  ),
                                ),
                              
                              const SizedBox(height: 4),
                              
                              Text(
                                _currentText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BounceRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;

  const BounceRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
  });

  @override
  State<BounceRefreshIndicator> createState() => _BounceRefreshIndicatorState();
}

class _BounceRefreshIndicatorState extends State<BounceRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.bounceOut,
    ));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.heavyImpact();
        _bounceController.forward().then((_) {
          _bounceController.reverse();
        });

        await widget.onRefresh();
      },
      color: widget.color ?? Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_bounceAnimation.value * 0.02),
            child: widget.child,
          );
        },
      ),
    );
  }
}