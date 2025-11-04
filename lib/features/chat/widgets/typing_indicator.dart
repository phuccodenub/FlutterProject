import 'package:flutter/material.dart';

/// Typing Indicator Widget
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key, required this.typingUsers});

  final List<String> typingUsers;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.typingUsers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.more_horiz, size: 16, color: Colors.grey),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      _getTypingText(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDot(0),
                          const SizedBox(width: 2),
                          _buildDot(1),
                          const SizedBox(width: 2),
                          _buildDot(2),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 40), // Space for alignment
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final delay = index * 0.2;
    final value = (_animation.value - delay).clamp(0.0, 1.0);
    final opacity = (Curves.easeInOut.transform(value) * 2 - 1).abs();

    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[600]?.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }

  String _getTypingText() {
    if (widget.typingUsers.length == 1) {
      return '${widget.typingUsers.first} đang nhập';
    } else if (widget.typingUsers.length == 2) {
      return '${widget.typingUsers[0]} và ${widget.typingUsers[1]} đang nhập';
    } else {
      return '${widget.typingUsers.length} người đang nhập';
    }
  }
}
