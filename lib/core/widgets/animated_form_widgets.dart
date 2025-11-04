import 'package:flutter/material.dart';
import '../animations/app_animations.dart';
import 'animated_buttons.dart';

class AnimatedTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final bool enabled;
  final String? errorText;
  final bool showError;

  const AnimatedTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.onTap,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.showError = false,
  });

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with TickerProviderStateMixin {
  late AnimationController _errorController;
  late Animation<double> _errorShakeAnimation;

  FocusNode? _focusNode;
  bool _hasFocus = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _errorController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );

    _errorShakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _errorController, curve: Curves.elasticIn),
    );
    // _borderColorAnimation is initialized in didChangeDependencies to avoid accessing Theme in initState
    _focusNode!.addListener(_onFocusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize or update the color tween based on current theme safely here
  }

  @override
  void didUpdateWidget(AnimatedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showError && !oldWidget.showError) {
      _triggerErrorAnimation();
    }
  }

  @override
  void dispose() {
    _focusNode?.removeListener(_onFocusChanged); // Dọn dẹp listener
    _focusNode?.dispose();
    // Bỏ _focusController.dispose()
    _errorController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    // Chỉ cần setState cho _hasFocus để cập nhật shadow
    if (mounted) {
      setState(() {
        _hasFocus = _focusNode!.hasFocus;
      });
    }
  }

  void _triggerErrorAnimation() {
    setState(() {
      _hasError = true;
    });

    _errorController.forward().then((_) {
      _errorController.reverse().then((_) {
        setState(() {
          _hasError = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // --- ĐỊNH NGHĨA CÁC VIỀN CHO TEXTFORMFIELD ---
    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: colorScheme.outline.withValues(alpha: 0.5),
        width: 1,
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: colorScheme.primary, // Màu viền khi focus
        width: 2,
      ),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: colorScheme.error, // Màu viền khi lỗi
        width: 1,
      ),
    );

    final focusedErrorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: colorScheme.error, // Màu viền khi vừa focus vừa lỗi
        width: 2,
      ),
    );
    // ---------------------------------------------

    return AnimatedBuilder(
      animation: _errorController, // Chỉ cần lắng nghe error controller
      builder: (context, child) {
        return Transform.translate(
          offset: _hasError
              ? Offset(
                  _errorShakeAnimation.value *
                      10 *
                      (1 - _errorShakeAnimation.value * 2).sign,
                  0,
                )
              : Offset.zero,
          child: child, // child ở đây là AnimatedContainer
        );
      },
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          // Giữ lại borderRadius và boxShadow
          borderRadius: BorderRadius.circular(12),
          boxShadow: _hasFocus
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
          // --- BỎ HOÀN TOÀN 'border' Ở ĐÂY ---
        ),
        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          enabled: widget.enabled,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            contentPadding: const EdgeInsets.all(16),

            // --- THAY 'border: InputBorder.none' BẰNG CÁC LOẠI VIỀN NÀY ---
            border: defaultBorder,
            enabledBorder: defaultBorder,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: focusedErrorBorder,

            // Tự động hiển thị lỗi (không cần widget riêng bên ngoài)
            errorText: widget.showError ? widget.errorText : null,

            // Bỏ labelStyle tùy chỉnh, để nó tự đổi màu theo theme (xanh khi focus, đỏ khi lỗi)
          ),
        ),
      ),
    );
  }
}

class AnimatedDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final String? labelText;
  final String? Function(T?)? validator;
  final Function(T?)? onChanged;
  final String Function(T) itemLabel;
  final bool enabled;
  final String? errorText;
  final bool showError;

  const AnimatedDropdown({
    super.key,
    required this.items,
    required this.itemLabel,
    this.value,
    this.labelText,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.showError = false,
  });

  @override
  State<AnimatedDropdown<T>> createState() => _AnimatedDropdownState<T>();
}

class _AnimatedDropdownState<T> extends State<AnimatedDropdown<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
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
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: AppAnimations.fast,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isExpanded
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    width: _isExpanded ? 2 : 1,
                  ),
                  boxShadow: _isExpanded
                      ? [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: DropdownButtonFormField<T>(
                  initialValue: widget.value,
                  items: widget.items.map((T item) {
                    return DropdownMenuItem<T>(
                      value: item,
                      child: FadeSlideAnimation(
                        child: Text(widget.itemLabel(item)),
                      ),
                    );
                  }).toList(),
                  onChanged: widget.enabled ? widget.onChanged : null,
                  validator: widget.validator,
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    labelStyle: TextStyle(
                      color: _isExpanded
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                  icon: Transform.rotate(
                    angle: _animation.value * 3.14159,
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
              ),
              if (widget.showError && widget.errorText != null)
                FadeSlideAnimation(
                  slideBegin: const Offset(0, -0.3),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, left: 16),
                    child: Text(
                      widget.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedCheckbox extends StatefulWidget {
  final bool value;
  final Function(bool?) onChanged;
  final String title;
  final String? subtitle;
  final Color? activeColor;

  const AnimatedCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.activeColor,
  });

  @override
  State<AnimatedCheckbox> createState() => _AnimatedCheckboxState();
}

class _AnimatedCheckboxState extends State<AnimatedCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.value) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BounceButton(
      onPressed: () => widget.onChanged(!widget.value),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            children: [
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.value
                          ? (widget.activeColor ??
                                Theme.of(context).primaryColor)
                          : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    color: widget.value
                        ? (widget.activeColor ?? Theme.of(context).primaryColor)
                        : Colors.transparent,
                  ),
                  child: widget.value
                      ? Transform.scale(
                          scale: _checkAnimation.value,
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (widget.subtitle != null)
                      Text(
                        widget.subtitle!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AnimatedFormSubmitButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final IconData? icon;

  const AnimatedFormSubmitButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.icon,
  });

  @override
  State<AnimatedFormSubmitButton> createState() =>
      _AnimatedFormSubmitButtonState();
}

class _AnimatedFormSubmitButtonState extends State<AnimatedFormSubmitButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _successController;
  late Animation<double> _widthAnimation;
  late Animation<double> _successAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _successController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );

    _widthAnimation = Tween<double>(
      begin: 1.0,
      end: 0.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _successAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(AnimatedFormSubmitButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLoading && !oldWidget.isLoading) {
      _controller.forward();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _controller.reverse();
    }

    if (widget.isSuccess && !oldWidget.isSuccess) {
      _successController.forward();
    } else if (!widget.isSuccess && oldWidget.isSuccess) {
      _successController.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _successController]),
      builder: (context, child) {
        return GlowButton(
          glowColor: widget.isError
              ? Colors.red
              : widget.isSuccess
              ? Colors.green
              : Theme.of(context).primaryColor,
          child: AnimatedContainer(
            duration: AppAnimations.normal,
            width: double.infinity * _widthAnimation.value.clamp(0.2, 1.0),
            height: 56,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isError
                    ? Colors.red
                    : widget.isSuccess
                    ? Colors.green
                    : Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    widget.isLoading ? 28 : 12,
                  ),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : widget.isSuccess
                  ? Transform.scale(
                      scale: _successAnimation.value,
                      child: const Icon(Icons.check, color: Colors.white),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
