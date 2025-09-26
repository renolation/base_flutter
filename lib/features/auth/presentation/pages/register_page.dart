import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

/// Beautiful and functional registration page with Material 3 design
/// Features comprehensive form validation, password confirmation, and responsive design
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;

  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _fadeAnimationController.forward();
      _slideAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }

    if (value.trim().split(' ').length < 2) {
      return 'Please enter your full name';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      _showErrorSnackBar('Please agree to the Terms of Service and Privacy Policy');
      return;
    }

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Clear any existing errors
    ref.read(authNotifierProvider.notifier).clearError();

    // TODO: Implement registration logic
    // For now, we'll simulate the registration process
    await _simulateRegistration();
  }

  Future<void> _simulateRegistration() async {
    // Show loading state
    setState(() {});

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Simulate successful registration
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            AppSpacing.horizontalSpaceSM,
            const Expanded(
              child: Text('Account created successfully! Please sign in.'),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).extension<AppColorsExtension>()?.success ??
            Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
        ),
      ),
    );

    // Navigate back to login
    Navigator.of(context).pop();
  }

  void _handleSignIn() {
    HapticFeedback.selectionClick();
    Navigator.of(context).pop();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.onError,
            ),
            AppSpacing.horizontalSpaceSM,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;

    // For simulation, we'll track loading state locally
    // In real implementation, this would come from auth state
    final isLoading = false; // Replace with actual auth state when implemented

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: AppSpacing.responsivePadding(context),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: AppSpacing.isMobile(context) ? double.infinity : 400,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Section
                        _buildHeaderSection(theme, colorScheme, isKeyboardVisible),

                        AppSpacing.verticalSpaceXXL,

                        // Form Fields
                        _buildFormSection(theme, colorScheme, isLoading),

                        AppSpacing.verticalSpaceXL,

                        // Terms Agreement
                        _buildTermsAgreement(theme, colorScheme, isLoading),

                        AppSpacing.verticalSpaceXL,

                        // Register Button
                        _buildRegisterButton(isLoading),

                        AppSpacing.verticalSpaceXL,

                        // Footer Links
                        _buildFooterSection(theme, colorScheme),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isKeyboardVisible,
  ) {
    return AnimatedContainer(
      duration: AppSpacing.animationNormal,
      height: isKeyboardVisible ? 100 : 140,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App Icon/Logo
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.person_add_outlined,
              size: isKeyboardVisible ? 40 : 56,
              color: colorScheme.primary,
            ),
          ),

          AppSpacing.verticalSpaceLG,

          // Welcome Text
          Text(
            'Create Account',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          AppSpacing.verticalSpaceSM,

          Text(
            'Sign up to get started',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isLoading,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Full Name Field
        AuthTextField(
          controller: _nameController,
          focusNode: _nameFocusNode,
          labelText: 'Full Name',
          hintText: 'Enter your full name',
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: _validateName,
          enabled: !isLoading,
          autofillHints: const [AutofillHints.name],
          prefixIcon: const Icon(Icons.person_outline),
          onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
        ),

        AppSpacing.verticalSpaceLG,

        // Email Field
        AuthTextField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          labelText: 'Email Address',
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: _validateEmail,
          enabled: !isLoading,
          autofillHints: const [AutofillHints.email],
          prefixIcon: const Icon(Icons.email_outlined),
          onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
        ),

        AppSpacing.verticalSpaceLG,

        // Password Field
        AuthTextField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          labelText: 'Password',
          hintText: 'Create a strong password',
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.next,
          validator: _validatePassword,
          enabled: !isLoading,
          autofillHints: const [AutofillHints.newPassword],
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: isLoading
                ? null
                : () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
            tooltip: _isPasswordVisible ? 'Hide password' : 'Show password',
          ),
          onFieldSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
        ),

        AppSpacing.verticalSpaceSM,

        // Password Requirements
        _buildPasswordRequirements(theme, colorScheme),

        AppSpacing.verticalSpaceLG,

        // Confirm Password Field
        AuthTextField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocusNode,
          labelText: 'Confirm Password',
          hintText: 'Confirm your password',
          obscureText: !_isConfirmPasswordVisible,
          textInputAction: TextInputAction.done,
          validator: _validateConfirmPassword,
          enabled: !isLoading,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: isLoading
                ? null
                : () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
            tooltip: _isConfirmPasswordVisible
                ? 'Hide password'
                : 'Show password',
          ),
          onFieldSubmitted: (_) => _handleRegister(),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements(ThemeData theme, ColorScheme colorScheme) {
    final password = _passwordController.text;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppSpacing.radiusSM,
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Requirements:',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalSpaceXS,
          _buildRequirementItem(
            'At least 8 characters',
            password.length >= 8,
            theme,
            colorScheme,
          ),
          _buildRequirementItem(
            'Contains uppercase letter',
            RegExp(r'[A-Z]').hasMatch(password),
            theme,
            colorScheme,
          ),
          _buildRequirementItem(
            'Contains lowercase letter',
            RegExp(r'[a-z]').hasMatch(password),
            theme,
            colorScheme,
          ),
          _buildRequirementItem(
            'Contains number',
            RegExp(r'\d').hasMatch(password),
            theme,
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(
    String text,
    bool isValid,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: isValid
              ? (theme.extension<AppColorsExtension>()?.success ?? colorScheme.primary)
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        AppSpacing.horizontalSpaceXS,
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isValid
                ? (theme.extension<AppColorsExtension>()?.success ?? colorScheme.primary)
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAgreement(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isLoading,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: isLoading
              ? null
              : (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        AppSpacing.horizontalSpaceSM,
        Expanded(
          child: Wrap(
            children: [
              Text(
                'I agree to the ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              InkWell(
                onTap: () {
                  // TODO: Navigate to terms of service
                },
                child: Text(
                  'Terms of Service',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                ' and ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              InkWell(
                onTap: () {
                  // TODO: Navigate to privacy policy
                },
                child: Text(
                  'Privacy Policy',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(bool isLoading) {
    return AuthButton(
      onPressed: isLoading ? null : _handleRegister,
      text: 'Create Account',
      isLoading: isLoading,
      type: AuthButtonType.filled,
      icon: isLoading ? null : const Icon(Icons.person_add),
    );
  }

  Widget _buildFooterSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Sign In Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: _handleSignIn,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

