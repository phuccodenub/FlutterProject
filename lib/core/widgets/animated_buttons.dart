import 'package:flutter/material.dart';
import '../animations/app_animations.dart';

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double elevation;
  final Duration animationDuration;
  final double scaleOnTap;
  final bool hapticFeedback;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
    this.elevation = 2,
    this.animationDuration = AppAnimations.fast,
    this.scaleOnTap = 0.95,
    this.hapticFeedback = true,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleOnTap,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation + 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: _elevationAnimation.value,
              color: widget.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              ),
              child: Padding(
                padding: widget.padding ?? const EdgeInsets.all(16),
                child: DefaultTextStyle(
                  style: TextStyle(color: widget.foregroundColor),
                  child: widget.child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PulseButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;
  final Duration pulseDuration;
  final double pulseScale;

  const PulseButton({
    super.key,
    required this.child,
    this.onPressed,
    this.color,
    this.pulseDuration = const Duration(milliseconds: 1000),
    this.pulseScale = 1.1,
  });

  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.pulseDuration,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pulseScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class RippleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? rippleColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const RippleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.rippleColor,
    this.borderRadius,
    this.padding,
  });

  @override
  State<RippleButton> createState() => _RippleButtonState();
}

class _RippleButtonState extends State<RippleButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: widget.borderRadius,
        splashColor: widget.rippleColor ?? Theme.of(context).primaryColor.withValues(alpha: 0.3),
        highlightColor: widget.rippleColor ?? Theme.of(context).primaryColor.withValues(alpha: 0.1),
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: widget.child,
        ),
      ),
    );
  }
}

class BounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration animationDuration;
  final double bounceScale;

  const BounceButton({
    super.key,
    required this.child,
    this.onPressed,
    this.animationDuration = AppAnimations.fast,
    this.bounceScale = 1.2,
  });

  @override
  State<BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<BounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: widget.bounceScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed != null ? _onTap : null,
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class ShakeButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration shakeDuration;
  final double shakeOffset;
  final bool triggerShake;

  const ShakeButton({
    super.key,
    required this.child,
    this.onPressed,
    this.shakeDuration = const Duration(milliseconds: 500),
    this.shakeOffset = 10.0,
    this.triggerShake = false,
  });

  @override
  State<ShakeButton> createState() => _ShakeButtonState();
}

class _ShakeButtonState extends State<ShakeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.shakeDuration,
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void didUpdateWidget(ShakeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.triggerShake && !oldWidget.triggerShake) {
      _shake();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _shake() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          final offset = _shakeAnimation.value * widget.shakeOffset * 
              (1 - _shakeAnimation.value) * 4;
          return Transform.translate(
            offset: Offset(offset * (1 - _shakeAnimation.value * 2).sign, 0),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class GlowButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? glowColor;
  final double glowRadius;
  final Duration animationDuration;

  const GlowButton({
    super.key,
    required this.child,
    this.onPressed,
    this.glowColor,
    this.glowRadius = 20.0,
    this.animationDuration = AppAnimations.normal,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = widget.glowColor ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: _glowAnimation.value * 0.6),
                  blurRadius: widget.glowRadius * _glowAnimation.value,
                  spreadRadius: widget.glowRadius * _glowAnimation.value * 0.3,
                ),
              ],
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}