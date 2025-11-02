import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaveRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? waveColor;

  const WaveRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.waveColor,
  });

  @override
  State<WaveRefreshIndicator> createState() => _WaveRefreshIndicatorState();
}

class _WaveRefreshIndicatorState extends State<WaveRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        _waveController.repeat();

        await widget.onRefresh();

        _waveController.stop();
        _waveController.reset();
      },
      color: widget.waveColor ?? Theme.of(context).primaryColor,
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: WavePainter(
              progress: _waveAnimation.value,
              color: widget.waveColor ?? Theme.of(context).primaryColor,
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  final Color color;

  WavePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0.0) return;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 20.0 * progress;
    final waveLength = size.width;

    path.moveTo(0, 0);
    
    for (double x = 0; x <= waveLength; x += 1) {
      final y = waveHeight * 
          math.sin((x / waveLength * 2 * math.pi) + (progress * 2 * math.pi));
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class SpringRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? springColor;

  const SpringRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.springColor,
  });

  @override
  State<SpringRefreshIndicator> createState() => _SpringRefreshIndicatorState();
}

class _SpringRefreshIndicatorState extends State<SpringRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _springController;
  late Animation<double> _springAnimation;

  @override
  void initState() {
    super.initState();
    
    _springController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _springAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _springController,
      curve: Curves.elasticInOut,
    ));
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.heavyImpact();
        
        // Spring animation
        _springController.forward().then((_) {
          _springController.reverse();
        });

        await widget.onRefresh();
      },
      color: widget.springColor ?? Theme.of(context).primaryColor,
      child: AnimatedBuilder(
        animation: _springAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _springAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class RippleRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? rippleColor;

  const RippleRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.rippleColor,
  });

  @override
  State<RippleRefreshIndicator> createState() => _RippleRefreshIndicatorState();
}

class _RippleRefreshIndicatorState extends State<RippleRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.lightImpact();
        
        // Ripple animation
        _rippleController.forward().then((_) {
          _rippleController.reset();
        });

        await widget.onRefresh();
      },
      color: widget.rippleColor ?? Theme.of(context).primaryColor,
      child: AnimatedBuilder(
        animation: _rippleAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: RipplePainter(
              progress: _rippleAnimation.value,
              color: widget.rippleColor ?? Theme.of(context).primaryColor,
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  RipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0.0) return;

    final paint = Paint()
      ..color = color.withValues(alpha: (1.0 - progress) * 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, 60);
    final radius = progress * 100;

    canvas.drawCircle(center, radius, paint);
    
    // Multiple ripples
    if (progress > 0.3) {
      canvas.drawCircle(
        center, 
        (progress - 0.3) * 80,
        paint..color = color.withValues(alpha: (1.0 - progress + 0.3) * 0.2),
      );
    }
    
    if (progress > 0.6) {
      canvas.drawCircle(
        center, 
        (progress - 0.6) * 60,
        paint..color = color.withValues(alpha: (1.0 - progress + 0.6) * 0.1),
      );
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}