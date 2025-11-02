import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../animations/app_animations.dart';

// Theme state provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>(
  (ref) => ThemeNotifier(),
);

enum ThemeMode { light, dark, system }

class ThemeState {
  final ThemeMode mode;
  final bool isTransitioning;
  final double transitionProgress;

  const ThemeState({
    this.mode = ThemeMode.system,
    this.isTransitioning = false,
    this.transitionProgress = 0.0,
  });

  ThemeState copyWith({
    ThemeMode? mode,
    bool? isTransitioning,
    double? transitionProgress,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      isTransitioning: isTransitioning ?? this.isTransitioning,
      transitionProgress: transitionProgress ?? this.transitionProgress,
    );
  }

  bool get isDark => mode == ThemeMode.dark;
  bool get isLight => mode == ThemeMode.light;
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState());

  Future<void> setTheme(ThemeMode newMode) async {
    if (state.mode == newMode || state.isTransitioning) return;

    state = state.copyWith(isTransitioning: true, transitionProgress: 0.0);

    // Animate transition progress
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 10));
      state = state.copyWith(transitionProgress: i / 100);
    }

    state = state.copyWith(
      mode: newMode,
      isTransitioning: false,
      transitionProgress: 1.0,
    );

    // Reset progress after transition
    await Future.delayed(const Duration(milliseconds: 100));
    state = state.copyWith(transitionProgress: 0.0);
  }

  void toggleTheme() {
    final newMode = state.isDark ? ThemeMode.light : ThemeMode.dark;
    setTheme(newMode);
  }
}

class AnimatedThemeWidget extends ConsumerStatefulWidget {
  final Widget child;

  const AnimatedThemeWidget({super.key, required this.child});

  @override
  ConsumerState<AnimatedThemeWidget> createState() => _AnimatedThemeWidgetState();
}

class _AnimatedThemeWidgetState extends ConsumerState<AnimatedThemeWidget>
    with TickerProviderStateMixin {
  late AnimationController _colorController;
  late AnimationController _iconController;
  late Animation<double> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    _colorController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _iconController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );

    _colorAnimation = CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    );


  }

  @override
  void dispose() {
    _colorController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);

    if (themeState.isTransitioning) {
      _colorController.forward();
      _iconController.forward().then((_) => _iconController.reverse());
    } else {
      _colorController.reverse();
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_colorController, _iconController]),
      builder: (context, child) {
        return AnimatedContainer(
          duration: AppAnimations.normal,
          decoration: BoxDecoration(
            gradient: themeState.isTransitioning
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1 * _colorAnimation.value),
                      Colors.white.withValues(alpha: 0.1 * _colorAnimation.value),
                    ],
                  )
                : null,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class ThemeToggleButton extends ConsumerStatefulWidget {
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const ThemeToggleButton({
    super.key,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  ConsumerState<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends ConsumerState<ThemeToggleButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.orange,
      end: Colors.blue,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTap() {
    ref.read(themeProvider.notifier).toggleTheme();
    _controller.forward().then((_) => _controller.reverse());
    _scaleController.forward().then((_) => _scaleController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);

    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _scaleController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _onTap,
            child: Transform.rotate(
              angle: _rotationAnimation.value * 6.28, // 2π rotation
              child: Container(
                width: widget.size * 2,
                height: widget.size * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (_colorAnimation.value ?? Colors.orange).withValues(alpha: 0.2),
                      (_colorAnimation.value ?? Colors.orange).withValues(alpha: 0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (_colorAnimation.value ?? Colors.orange).withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  themeState.isDark ? Icons.light_mode : Icons.dark_mode,
                  size: widget.size,
                  color: _colorAnimation.value ?? 
                         (themeState.isDark ? Colors.orange : Colors.blue),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedIconTheme extends ConsumerStatefulWidget {
  final IconData lightIcon;
  final IconData darkIcon;
  final double size;
  final Color? color;

  const AnimatedIconTheme({
    super.key,
    required this.lightIcon,
    required this.darkIcon,
    this.size = 24,
    this.color,
  });

  @override
  ConsumerState<AnimatedIconTheme> createState() => _AnimatedIconThemeState();
}

class _AnimatedIconThemeState extends ConsumerState<AnimatedIconTheme>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);

    if (themeState.isTransitioning) {
      _controller.forward();
    } else {
      if (themeState.isDark) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Light icon
            Transform.scale(
              scale: 1.0 - _animation.value,
              child: Opacity(
                opacity: 1.0 - _animation.value,
                child: Icon(
                  widget.lightIcon,
                  size: widget.size,
                  color: widget.color ?? Theme.of(context).iconTheme.color,
                ),
              ),
            ),
            
            // Dark icon
            Transform.scale(
              scale: _animation.value,
              child: Opacity(
                opacity: _animation.value,
                child: Icon(
                  widget.darkIcon,
                  size: widget.size,
                  color: widget.color ?? Theme.of(context).iconTheme.color,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ThemeTransitionOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const ThemeTransitionOverlay({super.key, required this.child});

  @override
  ConsumerState<ThemeTransitionOverlay> createState() => _ThemeTransitionOverlayState();
}

class _ThemeTransitionOverlayState extends ConsumerState<ThemeTransitionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _overlayController;
  late Animation<double> _overlayAnimation;

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );

    _overlayAnimation = CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);

    // Listen to theme changes
    ref.listen(themeProvider, (previous, next) {
      if (next.isTransitioning && !previous!.isTransitioning) {
        _overlayController.forward().then((_) {
          _overlayController.reverse();
        });
      }
    });

    return Stack(
      children: [
        widget.child,
        
        // Transition overlay
        if (themeState.isTransitioning)
          AnimatedBuilder(
            animation: _overlayAnimation,
            builder: (context, child) {
              return Container(
                color: (themeState.isDark ? Colors.black : Colors.white)
                    .withValues(alpha: 0.1 * _overlayAnimation.value),
              );
            },
          ),
      ],
    );
  }
}

class AnimatedBackgroundGradient extends ConsumerStatefulWidget {
  final Widget child;

  const AnimatedBackgroundGradient({super.key, required this.child});

  @override
  ConsumerState<AnimatedBackgroundGradient> createState() => _AnimatedBackgroundGradientState();
}

class _AnimatedBackgroundGradientState extends ConsumerState<AnimatedBackgroundGradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _gradientAnimation = CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeProvider);

    // Listen to theme changes
    ref.listen(themeProvider, (previous, next) {
      if (next.isTransitioning) {
        _gradientController.forward().then((_) {
          _gradientController.reverse();
        });
      }
    });

    return AnimatedBuilder(
      animation: _gradientAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).primaryColor.withValues(
                  alpha: 0.05 + (0.1 * _gradientAnimation.value),
                ),
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}