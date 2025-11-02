import 'package:flutter/material.dart';
import '../animations/app_animations.dart';

class AnimatedHero extends StatefulWidget {
  final String tag;
  final Widget child;
  final Duration? transitionDuration;
  final Curve? curve;
  final VoidCallback? onTap;

  const AnimatedHero({
    super.key,
    required this.tag,
    required this.child,
    this.transitionDuration,
    this.curve,
    this.onTap,
  });

  @override
  State<AnimatedHero> createState() => _AnimatedHeroState();
}

class _AnimatedHeroState extends State<AnimatedHero>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Hero(
              tag: widget.tag,
              transitionOnUserGestures: true,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

class ProfileHero extends StatelessWidget {
  final String heroTag;
  final String? imageUrl;
  final String name;
  final double radius;
  final VoidCallback? onTap;

  const ProfileHero({
    super.key,
    required this.heroTag,
    this.imageUrl,
    required this.name,
    this.radius = 30,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedHero(
      tag: heroTag,
      onTap: onTap,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null
              ? Icon(
                  Icons.person,
                  size: radius,
                  color: Theme.of(context).primaryColor,
                )
              : null,
        ),
      ),
    );
  }
}

class CourseCardHero extends StatelessWidget {
  final String heroTag;
  final String title;
  final String? description;
  final String? imageUrl;
  final Widget? trailing;
  final VoidCallback? onTap;
  final double? elevation;

  const CourseCardHero({
    super.key,
    required this.heroTag,
    required this.title,
    this.description,
    this.imageUrl,
    this.trailing,
    this.onTap,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedHero(
      tag: heroTag,
      onTap: onTap,
      child: Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withValues(alpha: 0.1),
                Theme.of(context).primaryColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl!,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 120,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
                
                if (description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StudentCardHero extends StatelessWidget {
  final String heroTag;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? status;
  final Color? statusColor;
  final VoidCallback? onTap;

  const StudentCardHero({
    super.key,
    required this.heroTag,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.status,
    this.statusColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedHero(
      tag: heroTag,
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ProfileHero(
                heroTag: '${heroTag}_avatar',
                imageUrl: avatarUrl,
                name: name,
                radius: 24,
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              if (status != null) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (statusColor ?? Colors.green).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status!,
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor ?? Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeroPageTransition<T> extends PageRouteBuilder<T> {
  final Widget child;

  HeroPageTransition({
    required this.child,
    super.transitionDuration = const Duration(milliseconds: 400),
    super.reverseTransitionDuration = const Duration(milliseconds: 300),
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.3, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      ),
    );
  }
}

// Helper extension for navigation with Hero animations
extension HeroNavigation on BuildContext {
  Future<T?> pushHeroRoute<T extends Object?>(Widget page) {
    return Navigator.of(this).push(
      HeroPageTransition(child: page),
    );
  }
}

class SharedAxisHeroTransition extends StatefulWidget {
  final String heroTag;
  final Widget child;
  final Axis axis;
  final Duration duration;

  const SharedAxisHeroTransition({
    super.key,
    required this.heroTag,
    required this.child,
    this.axis = Axis.horizontal,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<SharedAxisHeroTransition> createState() => _SharedAxisHeroTransitionState();
}

class _SharedAxisHeroTransitionState extends State<SharedAxisHeroTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Hero(
          tag: widget.heroTag,
          child: Transform.translate(
            offset: widget.axis == Axis.horizontal
                ? Offset(50 * (1 - _animation.value), 0)
                : Offset(0, 50 * (1 - _animation.value)),
            child: Opacity(
              opacity: _animation.value,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}