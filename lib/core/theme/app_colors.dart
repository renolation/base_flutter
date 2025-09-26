import 'package:flutter/material.dart';

/// App color schemes for light and dark modes following Material 3 guidelines
class AppColors {
  // Prevent instantiation
  AppColors._();

  /// Light theme color scheme
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    // Primary colors
    primary: Color(0xFF1976D2),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFBBDEFB),
    onPrimaryContainer: Color(0xFF0D47A1),
    // Secondary colors
    secondary: Color(0xFF0288D1),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFB3E5FC),
    onSecondaryContainer: Color(0xFF006064),
    // Tertiary colors
    tertiary: Color(0xFF7B1FA2),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE1BEE7),
    onTertiaryContainer: Color(0xFF4A148C),
    // Error colors
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFCDD2),
    onErrorContainer: Color(0xFFB71C1C),
    // Background colors
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF212121),
    surfaceContainerHighest: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFF757575),
    // Outline colors
    outline: Color(0xFFBDBDBD),
    outlineVariant: Color(0xFFE0E0E0),
    // Shadow and scrim
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    // Inverse colors
    inverseSurface: Color(0xFF303030),
    onInverseSurface: Color(0xFFFFFFFF),
    inversePrimary: Color(0xFF90CAF9),
  );

  /// Dark theme color scheme
  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    // Primary colors
    primary: Color(0xFF90CAF9),
    onPrimary: Color(0xFF0D47A1),
    primaryContainer: Color(0xFF1565C0),
    onPrimaryContainer: Color(0xFFE3F2FD),
    // Secondary colors
    secondary: Color(0xFF81D4FA),
    onSecondary: Color(0xFF006064),
    secondaryContainer: Color(0xFF0277BD),
    onSecondaryContainer: Color(0xFFE0F7FA),
    // Tertiary colors
    tertiary: Color(0xFFCE93D8),
    onTertiary: Color(0xFF4A148C),
    tertiaryContainer: Color(0xFF8E24AA),
    onTertiaryContainer: Color(0xFFF3E5F5),
    // Error colors
    error: Color(0xFFEF5350),
    onError: Color(0xFFB71C1C),
    errorContainer: Color(0xFFC62828),
    onErrorContainer: Color(0xFFFFEBEE),
    // Background colors
    surface: Color(0xFF121212),
    onSurface: Color(0xFFFFFFFF),
    surfaceContainerHighest: Color(0xFF1E1E1E),
    onSurfaceVariant: Color(0xFFBDBDBD),
    // Outline colors
    outline: Color(0xFF616161),
    outlineVariant: Color(0xFF424242),
    // Shadow and scrim
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    // Inverse colors
    inverseSurface: Color(0xFFE0E0E0),
    onInverseSurface: Color(0xFF303030),
    inversePrimary: Color(0xFF1976D2),
  );

  /// Semantic colors for common use cases
  static const Color success = Color(0xFF4CAF50);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFC8E6C9);
  static const Color onSuccessContainer = Color(0xFF1B5E20);

  static const Color warning = Color(0xFFFF9800);
  static const Color onWarning = Color(0xFF000000);
  static const Color warningContainer = Color(0xFFFFE0B2);
  static const Color onWarningContainer = Color(0xFFE65100);

  static const Color info = Color(0xFF2196F3);
  static const Color onInfo = Color(0xFFFFFFFF);
  static const Color infoContainer = Color(0xFFBBDEFB);
  static const Color onInfoContainer = Color(0xFF0D47A1);

  /// Surface elevation tints for Material 3
  static const List<Color> surfaceTintLight = [
    Color(0xFFFFFFFF), // elevation 0
    Color(0xFFFCFCFC), // elevation 1
    Color(0xFFF8F8F8), // elevation 2
    Color(0xFFF5F5F5), // elevation 3
    Color(0xFFF2F2F2), // elevation 4
    Color(0xFFEFEFEF), // elevation 5
  ];

  static const List<Color> surfaceTintDark = [
    Color(0xFF121212), // elevation 0
    Color(0xFF1E1E1E), // elevation 1
    Color(0xFF232323), // elevation 2
    Color(0xFF252525), // elevation 3
    Color(0xFF272727), // elevation 4
    Color(0xFF2C2C2C), // elevation 5
  ];

  /// Get surface color with elevation tint
  static Color getSurfaceColor(int elevation, bool isDark) {
    final tints = isDark ? surfaceTintDark : surfaceTintLight;
    final index = elevation.clamp(0, tints.length - 1);
    return tints[index];
  }

  /// Accessibility compliant color pairs
  static final Map<Color, Color> accessiblePairs = {
    // High contrast pairs for better accessibility
    const Color(0xFF000000): const Color(0xFFFFFFFF),
    const Color(0xFFFFFFFF): const Color(0xFF000000),
    const Color(0xFF1976D2): const Color(0xFFFFFFFF),
    const Color(0xFFD32F2F): const Color(0xFFFFFFFF),
    const Color(0xFF4CAF50): const Color(0xFFFFFFFF),
    const Color(0xFFFF9800): const Color(0xFF000000),
  };

  /// Check if color combination meets WCAG AA standards
  static bool isAccessible(Color background, Color foreground) {
    final bgLuminance = background.computeLuminance();
    final fgLuminance = foreground.computeLuminance();
    final ratio = (bgLuminance + 0.05) / (fgLuminance + 0.05);
    return ratio >= 4.5 || (1 / ratio) >= 4.5;
  }
}