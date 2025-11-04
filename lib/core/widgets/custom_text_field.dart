import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

enum TextFieldVariant { outlined, filled, underlined }

enum TextFieldSize { small, medium, large }

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.variant = TextFieldVariant.outlined,
    this.size = TextFieldSize.medium,
    this.autofocus = false,
    this.focusNode,
    this.initialValue,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextFieldVariant variant;
  final TextFieldSize size;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? initialValue;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: _getLabelStyle()),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          initialValue: widget.initialValue,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          autofocus: widget.autofocus,
          style: _getTextStyle(),
          decoration: _getInputDecoration(),
        ),
        if (widget.helperText != null || widget.errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.errorText ?? widget.helperText!,
            style: _getHelperTextStyle(),
          ),
        ],
      ],
    );
  }

  InputDecoration _getInputDecoration() {
    final hasError = widget.errorText != null;

    switch (widget.variant) {
      case TextFieldVariant.outlined:
        return InputDecoration(
          hintText: widget.hint,
          hintStyle: _getHintStyle(),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          filled: false,
          contentPadding: _getContentPadding(),
          border: _getOutlinedBorder(AppColors.grey300),
          enabledBorder: _getOutlinedBorder(AppColors.grey300),
          focusedBorder: _getOutlinedBorder(
            hasError ? AppColors.error : AppColors.primary,
            width: 2,
          ),
          errorBorder: _getOutlinedBorder(AppColors.error),
          focusedErrorBorder: _getOutlinedBorder(AppColors.error, width: 2),
          disabledBorder: _getOutlinedBorder(AppColors.grey200),
        );

      case TextFieldVariant.filled:
        return InputDecoration(
          hintText: widget.hint,
          hintStyle: _getHintStyle(),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          filled: true,
          fillColor: _getFillColor(),
          contentPadding: _getContentPadding(),
          border: _getFilledBorder(),
          enabledBorder: _getFilledBorder(),
          focusedBorder: _getFilledBorder().copyWith(
            borderSide: BorderSide(
              color: hasError ? AppColors.error : AppColors.primary,
              width: 2,
            ),
          ),
          errorBorder: _getFilledBorder().copyWith(
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: _getFilledBorder().copyWith(
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          disabledBorder: _getFilledBorder(),
        );

      case TextFieldVariant.underlined:
        return InputDecoration(
          hintText: widget.hint,
          hintStyle: _getHintStyle(),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          filled: false,
          contentPadding: _getContentPadding(),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.grey300),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.grey300),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: hasError ? AppColors.error : AppColors.primary,
              width: 2,
            ),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.error, width: 2),
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.grey200),
          ),
        );
    }
  }

  OutlineInputBorder _getOutlinedBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  OutlineInputBorder _getFilledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: BorderSide.none,
    );
  }

  EdgeInsets _getContentPadding() {
    switch (widget.size) {
      case TextFieldSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case TextFieldSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        );
      case TextFieldSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        );
    }
  }

  Color _getFillColor() {
    if (!widget.enabled) return AppColors.grey100;
    return _isFocused ? AppColors.white : AppColors.grey50;
  }

  TextStyle _getLabelStyle() {
    return AppTypography.labelMedium.copyWith(
      color: widget.errorText != null ? AppColors.error : AppColors.grey700,
    );
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case TextFieldSize.small:
        return AppTypography.bodySmall.copyWith(
          color: widget.enabled ? AppColors.grey900 : AppColors.grey400,
        );
      case TextFieldSize.medium:
        return AppTypography.bodyMedium.copyWith(
          color: widget.enabled ? AppColors.grey900 : AppColors.grey400,
        );
      case TextFieldSize.large:
        return AppTypography.bodyLarge.copyWith(
          color: widget.enabled ? AppColors.grey900 : AppColors.grey400,
        );
    }
  }

  TextStyle _getHintStyle() {
    switch (widget.size) {
      case TextFieldSize.small:
        return AppTypography.bodySmall.copyWith(color: AppColors.grey400);
      case TextFieldSize.medium:
        return AppTypography.bodyMedium.copyWith(color: AppColors.grey400);
      case TextFieldSize.large:
        return AppTypography.bodyLarge.copyWith(color: AppColors.grey400);
    }
  }

  TextStyle _getHelperTextStyle() {
    return AppTypography.caption.copyWith(
      color: widget.errorText != null ? AppColors.error : AppColors.grey500,
    );
  }
}
