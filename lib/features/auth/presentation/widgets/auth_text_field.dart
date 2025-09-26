import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_spacing.dart';

/// Reusable styled text field specifically designed for authentication forms
/// Follows Material 3 design guidelines with consistent theming
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.obscureText = false,
    this.enabled = true,
    this.autofillHints,
    this.inputFormatters,
    this.maxLength,
    this.focusNode,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final bool obscureText;
  final bool enabled;
  final List<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChanged);
    }
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          autofocus: widget.autofocus,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: widget.enabled ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.38),
          ),
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.sm),
                    child: IconTheme.merge(
                      data: IconThemeData(
                        color: _isFocused
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        size: AppSpacing.iconMD,
                      ),
                      child: widget.prefixIcon!,
                    ),
                  )
                : null,
            suffixIcon: widget.suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    child: IconTheme.merge(
                      data: IconThemeData(
                        color: _isFocused
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        size: AppSpacing.iconMD,
                      ),
                      child: widget.suffixIcon!,
                    ),
                  )
                : null,
            filled: true,
            fillColor: widget.enabled
                ? (_isFocused
                    ? colorScheme.primaryContainer.withValues(alpha: 0.08)
                    : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5))
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            border: OutlineInputBorder(
              borderRadius: AppSpacing.fieldRadius,
              borderSide: BorderSide(
                color: colorScheme.outline,
                width: AppSpacing.borderWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.fieldRadius,
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.6),
                width: AppSpacing.borderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSpacing.fieldRadius,
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: AppSpacing.borderWidthThick,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppSpacing.fieldRadius,
              borderSide: BorderSide(
                color: colorScheme.error,
                width: AppSpacing.borderWidth,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppSpacing.fieldRadius,
              borderSide: BorderSide(
                color: colorScheme.error,
                width: AppSpacing.borderWidthThick,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: AppSpacing.fieldRadius,
              borderSide: BorderSide(
                color: colorScheme.onSurface.withValues(alpha: 0.12),
                width: AppSpacing.borderWidth,
              ),
            ),
            labelStyle: theme.textTheme.bodyMedium?.copyWith(
              color: _isFocused
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
            ),
            counterStyle: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          // Enhanced visual feedback with subtle animations
          cursorColor: colorScheme.primary,
          cursorHeight: 24,
          cursorWidth: 2,
        ),
      ],
    );
  }
}