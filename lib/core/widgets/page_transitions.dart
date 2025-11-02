import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../animations/app_animations.dart';

enum PageTransitionType {
  slide,
  fade,
  scale,
  slideUp,
  slideDown,
  rotateScale,
}

class CustomPageTransition {
  static CustomTransitionPage buildTransition({
    required Widget child,
    required GoRouterState state,
    PageTransitionType type = PageTransitionType.slide,
    Duration duration = AppAnimations.normal,
    Curve curve = Curves.easeInOut,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          type: type,
          curve: curve,
        );
      },
    );
  }

  static Widget _buildTransition({
    required Widget child,
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required PageTransitionType type,
    required Curve curve,
  }) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

    switch (type) {
      case PageTransitionType.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case PageTransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case PageTransitionType.slideDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case PageTransitionType.fade:
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );

      case PageTransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );

      case PageTransitionType.rotateScale:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.1,
            end: 0.0,
          ).animate(curvedAnimation),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(curvedAnimation),
            child: FadeTransition(
              opacity: curvedAnimation,
              child: child,
            ),
          ),
        );
    }
  }

  // Specific transition builders for different screen types
  static CustomTransitionPage authTransition({
    required Widget child,
    required GoRouterState state,
  }) {
    return buildTransition(
      child: child,
      state: state,
      type: PageTransitionType.slideUp,
      duration: AppAnimations.normal,
      curve: AppAnimations.materialCurve,
    );
  }

  static CustomTransitionPage dialogTransition({
    required Widget child,
    required GoRouterState state,
  }) {
    return buildTransition(
      child: child,
      state: state,
      type: PageTransitionType.scale,
      duration: AppAnimations.fast,
      curve: AppAnimations.elasticOut,
    );
  }

  static CustomTransitionPage detailTransition({
    required Widget child,
    required GoRouterState state,
  }) {
    return buildTransition(
      child: child,
      state: state,
      type: PageTransitionType.slide,
      duration: AppAnimations.normal,
      curve: AppAnimations.materialCurve,
    );
  }

  static CustomTransitionPage listTransition({
    required Widget child,
    required GoRouterState state,
  }) {
    return buildTransition(
      child: child,
      state: state,
      type: PageTransitionType.fade,
      duration: AppAnimations.fast,
      curve: AppAnimations.easeOut,
    );
  }

  static CustomTransitionPage settingsTransition({
    required Widget child,
    required GoRouterState state,
  }) {
    return buildTransition(
      child: child,
      state: state,
      type: PageTransitionType.slideDown,
      duration: AppAnimations.normal,
      curve: AppAnimations.materialCurve,
    );
  }

  // Hero transition wrapper
  static CustomTransitionPage heroTransition({
    required Widget child,
    required GoRouterState state,
    String? heroTag,
  }) {
    return buildTransition(
      child: heroTag != null
          ? Hero(
              tag: heroTag,
              child: Material(
                type: MaterialType.transparency,
                child: child,
              ),
            )
          : child,
      state: state,
      type: PageTransitionType.fade,
      duration: AppAnimations.normal,
    );
  }
}

// Extension to make route building easier
extension GoRouteExtensions on GoRoute {
  static GoRoute slideRoute({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
    String? Function(BuildContext, GoRouterState)? redirect,
    PageTransitionType transitionType = PageTransitionType.slide,
  }) {
    return GoRoute(
      path: path,
      redirect: redirect,
      pageBuilder: (context, state) => CustomPageTransition.buildTransition(
        child: builder(context, state),
        state: state,
        type: transitionType,
      ),
    );
  }

  static GoRoute fadeRoute({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
    String? Function(BuildContext, GoRouterState)? redirect,
  }) {
    return GoRoute(
      path: path,
      redirect: redirect,
      pageBuilder: (context, state) => CustomPageTransition.buildTransition(
        child: builder(context, state),
        state: state,
        type: PageTransitionType.fade,
      ),
    );
  }

  static GoRoute scaleRoute({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
    String? Function(BuildContext, GoRouterState)? redirect,
  }) {
    return GoRoute(
      path: path,
      redirect: redirect,
      pageBuilder: (context, state) => CustomPageTransition.buildTransition(
        child: builder(context, state),
        state: state,
        type: PageTransitionType.scale,
      ),
    );
  }
}