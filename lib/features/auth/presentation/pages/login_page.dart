import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

/// Beautiful and functional login page with Material 3 design
/// Features responsive design, form validation, and proper state management
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

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
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
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

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Clear any existing errors
    ref.read(authNotifierProvider.notifier).clearError();

    // Attempt login
    await ref.read(authNotifierProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _handleForgotPassword() {
    HapticFeedback.selectionClick();
    // TODO: Navigate to forgot password page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Forgot password functionality coming soon'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: AppSpacing.lg,
          right: AppSpacing.lg,
        ),
      ),
    );
  }

  void _handleSignUp() {
    HapticFeedback.selectionClick();
    Navigator.of(context).pushNamed('/auth/register');
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

    // Listen to auth state changes
    ref.listen<AuthState>(authNotifierProvider, (previous, current) {
      current.when(
        initial: () {},
        loading: () {},
        authenticated: (user) {
          // TODO: Navigate to home page
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: theme.extension<AppColorsExtension>()?.onSuccess ??
                        colorScheme.onPrimary,
                  ),
                  AppSpacing.horizontalSpaceSM,
                  Text('Welcome back, ${user.name}!'),
                ],
              ),
              backgroundColor: theme.extension<AppColorsExtension>()?.success ??
                  colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                bottom: mediaQuery.size.height * 0.1,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
              ),
            ),
          );
        },
        unauthenticated: (message) {
          if (message != null) {
            _showErrorSnackBar(message);
          }
        },
        error: (message) {
          _showErrorSnackBar(message);
        },
      );
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthStateLoading;

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                        // App Logo and Welcome Section
                        _buildHeaderSection(theme, colorScheme, isKeyboardVisible),

                        AppSpacing.verticalSpaceXXL,

                        // Form Fields
                        _buildFormSection(theme, colorScheme, isLoading),

                        AppSpacing.verticalSpaceXXL,

                        // Login Button
                        _buildLoginButton(isLoading),

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
      height: isKeyboardVisible ? 120 : 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App Icon/Logo
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.lock_person_outlined,
              size: isKeyboardVisible ? 48 : 64,
              color: colorScheme.primary,
            ),
          ),

          AppSpacing.verticalSpaceLG,

          // Welcome Text
          Text(
            'Welcome Back',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          AppSpacing.verticalSpaceSM,

          Text(
            'Sign in to continue to your account',
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
          hintText: 'Enter your password',
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.done,
          validator: _validatePassword,
          enabled: !isLoading,
          autofillHints: const [AutofillHints.password],
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
          onFieldSubmitted: (_) => _handleLogin(),
        ),

        AppSpacing.verticalSpaceMD,

        // Remember Me and Forgot Password Row
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            AppSpacing.horizontalSpaceSM,
            Expanded(
              child: Text(
                'Remember me',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: isLoading ? null : _handleForgotPassword,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: isLoading
                      ? colorScheme.onSurface.withValues(alpha: 0.38)
                      : colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return AuthButton(
      onPressed: isLoading ? null : _handleLogin,
      text: 'Sign In',
      isLoading: isLoading,
      type: AuthButtonType.filled,
      icon: isLoading ? null : const Icon(Icons.login),
    );
  }

  Widget _buildFooterSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Divider with "or" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: colorScheme.outlineVariant,
                thickness: 1,
              ),
            ),
            Padding(
              padding: AppSpacing.horizontalLG,
              child: Text(
                'or',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: colorScheme.outlineVariant,
                thickness: 1,
              ),
            ),
          ],
        ),

        AppSpacing.verticalSpaceXL,

        // Sign Up Link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: _handleSignUp,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        AppSpacing.verticalSpaceLG,

        // Privacy and Terms
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              'By continuing, you agree to our ',
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
      ],
    );
  }
}

