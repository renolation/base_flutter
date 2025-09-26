import 'package:flutter/material.dart';

/// Typography system following Material 3 guidelines
class AppTypography {
  // Prevent instantiation
  AppTypography._();

  /// Base font family
  static const String fontFamily = 'Roboto';

  /// Display styles - Largest, reserved for short, important text
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
  );

  /// Headline styles - High-emphasis text for headings
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.29,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
  );

  /// Title styles - Medium-emphasis text for titles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.50,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  /// Label styles - Small text for labels and captions
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );

  /// Body styles - Used for long-form writing
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.50,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  /// Create a complete TextTheme for the app
  static TextTheme textTheme = const TextTheme(
    // Display styles
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    // Headline styles
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    // Title styles
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    // Label styles
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
    // Body styles
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
  );

  /// Responsive typography that scales based on screen size
  static TextTheme responsiveTextTheme(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleFactor = _getScaleFactor(size.width);

    return TextTheme(
      displayLarge: displayLarge.copyWith(fontSize: displayLarge.fontSize! * scaleFactor),
      displayMedium: displayMedium.copyWith(fontSize: displayMedium.fontSize! * scaleFactor),
      displaySmall: displaySmall.copyWith(fontSize: displaySmall.fontSize! * scaleFactor),
      headlineLarge: headlineLarge.copyWith(fontSize: headlineLarge.fontSize! * scaleFactor),
      headlineMedium: headlineMedium.copyWith(fontSize: headlineMedium.fontSize! * scaleFactor),
      headlineSmall: headlineSmall.copyWith(fontSize: headlineSmall.fontSize! * scaleFactor),
      titleLarge: titleLarge.copyWith(fontSize: titleLarge.fontSize! * scaleFactor),
      titleMedium: titleMedium.copyWith(fontSize: titleMedium.fontSize! * scaleFactor),
      titleSmall: titleSmall.copyWith(fontSize: titleSmall.fontSize! * scaleFactor),
      labelLarge: labelLarge.copyWith(fontSize: labelLarge.fontSize! * scaleFactor),
      labelMedium: labelMedium.copyWith(fontSize: labelMedium.fontSize! * scaleFactor),
      labelSmall: labelSmall.copyWith(fontSize: labelSmall.fontSize! * scaleFactor),
      bodyLarge: bodyLarge.copyWith(fontSize: bodyLarge.fontSize! * scaleFactor),
      bodyMedium: bodyMedium.copyWith(fontSize: bodyMedium.fontSize! * scaleFactor),
      bodySmall: bodySmall.copyWith(fontSize: bodySmall.fontSize! * scaleFactor),
    );
  }

  /// Calculate scale factor based on screen width
  static double _getScaleFactor(double width) {
    if (width < 360) {
      return 0.9; // Small phones
    } else if (width < 600) {
      return 1.0; // Normal phones
    } else if (width < 840) {
      return 1.1; // Large phones / small tablets
    } else {
      return 1.2; // Tablets and larger
    }
  }

  /// Font weight extensions for better readability
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  /// Common text styles for specific use cases
  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle captionText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static const TextStyle overlineText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.6,
  );

  static const TextStyle errorText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static const TextStyle hintText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.50,
  );

  /// Text styles with semantic colors
  static TextStyle success(BuildContext context) => bodyMedium.copyWith(
    color: Theme.of(context).extension<AppColorsExtension>()?.success,
  );

  static TextStyle warning(BuildContext context) => bodyMedium.copyWith(
    color: Theme.of(context).extension<AppColorsExtension>()?.warning,
  );

  static TextStyle error(BuildContext context) => bodyMedium.copyWith(
    color: Theme.of(context).colorScheme.error,
  );

  static TextStyle info(BuildContext context) => bodyMedium.copyWith(
    color: Theme.of(context).extension<AppColorsExtension>()?.info,
  );
}

/// Theme extension for custom semantic colors
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color? success;
  final Color? onSuccess;
  final Color? successContainer;
  final Color? onSuccessContainer;
  final Color? warning;
  final Color? onWarning;
  final Color? warningContainer;
  final Color? onWarningContainer;
  final Color? info;
  final Color? onInfo;
  final Color? infoContainer;
  final Color? onInfoContainer;

  const AppColorsExtension({
    this.success,
    this.onSuccess,
    this.successContainer,
    this.onSuccessContainer,
    this.warning,
    this.onWarning,
    this.warningContainer,
    this.onWarningContainer,
    this.info,
    this.onInfo,
    this.infoContainer,
    this.onInfoContainer,
  });

  @override
  AppColorsExtension copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
  }) {
    return AppColorsExtension(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    );
  }

  @override
  AppColorsExtension lerp(covariant ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      success: Color.lerp(success, other.success, t),
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t),
      successContainer: Color.lerp(successContainer, other.successContainer, t),
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t),
      warning: Color.lerp(warning, other.warning, t),
      onWarning: Color.lerp(onWarning, other.onWarning, t),
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t),
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t),
      info: Color.lerp(info, other.info, t),
      onInfo: Color.lerp(onInfo, other.onInfo, t),
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t),
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t),
    );
  }

  /// Light theme extension
  static const AppColorsExtension light = AppColorsExtension(
    success: Color(0xFF4CAF50),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFC8E6C9),
    onSuccessContainer: Color(0xFF1B5E20),
    warning: Color(0xFFFF9800),
    onWarning: Color(0xFF000000),
    warningContainer: Color(0xFFFFE0B2),
    onWarningContainer: Color(0xFFE65100),
    info: Color(0xFF2196F3),
    onInfo: Color(0xFFFFFFFF),
    infoContainer: Color(0xFFBBDEFB),
    onInfoContainer: Color(0xFF0D47A1),
  );

  /// Dark theme extension
  static const AppColorsExtension dark = AppColorsExtension(
    success: Color(0xFF66BB6A),
    onSuccess: Color(0xFF1B5E20),
    successContainer: Color(0xFF2E7D32),
    onSuccessContainer: Color(0xFFC8E6C9),
    warning: Color(0xFFFFB74D),
    onWarning: Color(0xFFE65100),
    warningContainer: Color(0xFFF57C00),
    onWarningContainer: Color(0xFFFFE0B2),
    info: Color(0xFF42A5F5),
    onInfo: Color(0xFF0D47A1),
    infoContainer: Color(0xFF1976D2),
    onInfoContainer: Color(0xFFBBDEFB),
  );
}