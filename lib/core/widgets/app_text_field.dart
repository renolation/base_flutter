import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Text input field with validation, error handling, and Material 3 styling
///
/// Provides comprehensive form input functionality with built-in validation,
/// accessibility support, and consistent theming.
class AppTextField extends StatefulWidget {
  /// Creates a text input field with the specified configuration
  const AppTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.style,
    this.filled,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.semanticLabel,
  });

  /// Controls the text being edited
  final TextEditingController? controller;

  /// Initial value for the field (if no controller provided)
  final String? initialValue;

  /// Label text displayed above the field
  final String? labelText;

  /// Hint text displayed when field is empty
  final String? hintText;

  /// Helper text displayed below the field
  final String? helperText;

  /// Error text displayed below the field (overrides helper text)
  final String? errorText;

  /// Icon displayed at the start of the field
  final Widget? prefixIcon;

  /// Icon displayed at the end of the field
  final Widget? suffixIcon;

  /// Called when the field value changes
  final ValueChanged<String>? onChanged;

  /// Called when the field is submitted
  final ValueChanged<String>? onSubmitted;

  /// Called when the field is tapped
  final VoidCallback? onTap;

  /// Validator function for form validation
  final FormFieldValidator<String>? validator;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether the field is read-only
  final bool readOnly;

  /// Whether to obscure the text (for passwords)
  final bool obscureText;

  /// Whether to enable autocorrect
  final bool autocorrect;

  /// Whether to enable input suggestions
  final bool enableSuggestions;

  /// Maximum number of lines
  final int? maxLines;

  /// Minimum number of lines
  final int? minLines;

  /// Maximum character length
  final int? maxLength;

  /// Keyboard type for input
  final TextInputType? keyboardType;

  /// Text input action for the keyboard
  final TextInputAction? textInputAction;

  /// Input formatters to apply
  final List<TextInputFormatter>? inputFormatters;

  /// Focus node for the field
  final FocusNode? focusNode;

  /// Text capitalization behavior
  final TextCapitalization textCapitalization;

  /// Text alignment within the field
  final TextAlign textAlign;

  /// Text style override
  final TextStyle? style;

  /// Whether the field should be filled
  final bool? filled;

  /// Fill color override
  final Color? fillColor;

  /// Border radius override
  final BorderRadius? borderRadius;

  /// Content padding override
  final EdgeInsets? contentPadding;

  /// Semantic label for accessibility
  final String? semanticLabel;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Build suffix icon with password visibility toggle if needed
    Widget? suffixIcon = widget.suffixIcon;
    if (widget.obscureText) {
      suffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          size: AppSpacing.iconMD,
        ),
        onPressed: _toggleObscureText,
        tooltip: _obscureText ? 'Show password' : 'Hide password',
      );
    }

    // Create input decoration
    final inputDecoration = InputDecoration(
      labelText: widget.labelText,
      hintText: widget.hintText,
      helperText: widget.helperText,
      errorText: widget.errorText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: suffixIcon,
      filled: widget.filled ?? theme.inputDecorationTheme.filled,
      fillColor: widget.fillColor ??
          (widget.enabled
              ? theme.inputDecorationTheme.fillColor
              : colorScheme.surface.withOpacity(0.1)),
      contentPadding: widget.contentPadding ??
          theme.inputDecorationTheme.contentPadding,
      border: _createBorder(theme, null),
      enabledBorder: _createBorder(theme, colorScheme.outline),
      focusedBorder: _createBorder(theme, colorScheme.primary),
      errorBorder: _createBorder(theme, colorScheme.error),
      focusedErrorBorder: _createBorder(theme, colorScheme.error),
      disabledBorder: _createBorder(theme, colorScheme.outline.withOpacity(0.38)),
      labelStyle: theme.inputDecorationTheme.labelStyle?.copyWith(
        color: _getLabelColor(theme, colorScheme),
      ),
      hintStyle: widget.style ?? theme.inputDecorationTheme.hintStyle,
      errorStyle: theme.inputDecorationTheme.errorStyle,
      helperStyle: theme.inputDecorationTheme.helperStyle,
      counterStyle: AppTypography.bodySmall.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );

    // Create the text field
    Widget textField = TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: inputDecoration,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      obscureText: _obscureText,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      textAlign: widget.textAlign,
      style: widget.style ?? theme.inputDecorationTheme.labelStyle,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
    );

    // Add semantic label if provided
    if (widget.semanticLabel != null) {
      textField = Semantics(
        label: widget.semanticLabel,
        child: textField,
      );
    }

    return textField;
  }

  /// Create input border with custom styling
  InputBorder _createBorder(ThemeData theme, Color? borderColor) {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? AppSpacing.fieldRadius,
      borderSide: BorderSide(
        color: borderColor ?? Colors.transparent,
        width: _isFocused ? AppSpacing.borderWidthThick : AppSpacing.borderWidth,
      ),
    );
  }

  /// Get appropriate label color based on state
  Color _getLabelColor(ThemeData theme, ColorScheme colorScheme) {
    if (!widget.enabled) {
      return colorScheme.onSurface.withOpacity(0.38);
    }
    if (widget.errorText != null) {
      return colorScheme.error;
    }
    if (_isFocused) {
      return colorScheme.primary;
    }
    return colorScheme.onSurfaceVariant;
  }
}

/// Email validation text field
class AppEmailField extends StatelessWidget {
  const AppEmailField({
    super.key,
    this.controller,
    this.labelText = 'Email',
    this.hintText = 'Enter your email address',
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: const Icon(Icons.email_outlined),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      enableSuggestions: false,
      textCapitalization: TextCapitalization.none,
      onChanged: onChanged,
      validator: validator ?? _defaultEmailValidator,
      enabled: enabled,
      readOnly: readOnly,
      semanticLabel: 'Email address input field',
    );
  }

  String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }
}

/// Password validation text field
class AppPasswordField extends StatelessWidget {
  const AppPasswordField({
    super.key,
    this.controller,
    this.labelText = 'Password',
    this.hintText = 'Enter your password',
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.requireStrong = false,
  });

  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final bool readOnly;
  final bool requireStrong;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: const Icon(Icons.lock_outline),
      obscureText: true,
      textInputAction: TextInputAction.done,
      autocorrect: false,
      enableSuggestions: false,
      onChanged: onChanged,
      validator: validator ?? (requireStrong ? _strongPasswordValidator : _defaultPasswordValidator),
      enabled: enabled,
      readOnly: readOnly,
      semanticLabel: 'Password input field',
    );
  }

  String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _strongPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
    }
    return null;
  }
}

/// Search text field with built-in search functionality
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool enabled;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      prefixIcon: const Icon(Icons.search),
      suffixIcon: controller?.text.isNotEmpty == true
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller?.clear();
                onClear?.call();
              },
              tooltip: 'Clear search',
            )
          : null,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      semanticLabel: 'Search input field',
    );
  }
}