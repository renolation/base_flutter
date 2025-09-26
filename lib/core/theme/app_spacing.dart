import 'package:flutter/material.dart';

/// Consistent spacing system following Material 3 guidelines
class AppSpacing {
  // Prevent instantiation
  AppSpacing._();

  /// Base spacing unit (4dp in Material Design)
  static const double base = 4.0;

  /// Spacing scale based on Material 3 8dp grid system
  static const double xs = base;      // 4dp
  static const double sm = base * 2;  // 8dp
  static const double md = base * 3;  // 12dp
  static const double lg = base * 4;  // 16dp
  static const double xl = base * 5;  // 20dp
  static const double xxl = base * 6; // 24dp
  static const double xxxl = base * 8; // 32dp

  /// Semantic spacing values
  static const double tiny = xs;       // 4dp
  static const double small = sm;      // 8dp
  static const double medium = lg;     // 16dp
  static const double large = xxl;     // 24dp
  static const double huge = xxxl;     // 32dp

  /// Screen margins and padding
  static const double screenPadding = lg;           // 16dp
  static const double screenPaddingLarge = xxl;     // 24dp
  static const double screenMargin = lg;            // 16dp
  static const double screenMarginLarge = xxl;      // 24dp

  /// Card and container spacing
  static const double cardPadding = lg;             // 16dp
  static const double cardPaddingLarge = xxl;       // 24dp
  static const double cardMargin = sm;              // 8dp
  static const double cardBorderRadius = md;        // 12dp
  static const double cardBorderRadiusLarge = lg;   // 16dp

  /// Button spacing
  static const double buttonPadding = lg;           // 16dp
  static const double buttonPaddingVertical = md;   // 12dp
  static const double buttonPaddingHorizontal = xxl; // 24dp
  static const double buttonSpacing = sm;           // 8dp
  static const double buttonBorderRadius = md;      // 12dp

  /// Icon spacing
  static const double iconSpacing = sm;             // 8dp
  static const double iconMargin = xs;              // 4dp

  /// List item spacing
  static const double listItemPadding = lg;         // 16dp
  static const double listItemSpacing = sm;         // 8dp
  static const double listItemMargin = xs;          // 4dp

  /// Form field spacing
  static const double fieldSpacing = lg;            // 16dp
  static const double fieldPadding = lg;            // 16dp
  static const double fieldBorderRadius = sm;       // 8dp

  /// Component spacing
  static const double componentSpacing = sm;        // 8dp
  static const double componentMargin = xs;         // 4dp
  static const double componentPadding = md;        // 12dp

  /// Divider and border spacing
  static const double dividerSpacing = lg;          // 16dp
  static const double borderWidth = 1.0;
  static const double borderWidthThin = 0.5;
  static const double borderWidthThick = 2.0;

  /// Common EdgeInsets presets
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);
  static const EdgeInsets paddingXXXL = EdgeInsets.all(xxxl);

  /// Horizontal padding presets
  static const EdgeInsets horizontalXS = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets horizontalXXL = EdgeInsets.symmetric(horizontal: xxl);

  /// Vertical padding presets
  static const EdgeInsets verticalXS = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLG = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXL = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets verticalXXL = EdgeInsets.symmetric(vertical: xxl);

  /// Screen padding presets
  static const EdgeInsets screenPaddingAll = EdgeInsets.all(screenPadding);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: screenPadding);
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(vertical: screenPadding);

  /// Safe area padding that respects system UI
  static EdgeInsets safeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return EdgeInsets.only(
      top: mediaQuery.padding.top + screenPadding,
      bottom: mediaQuery.padding.bottom + screenPadding,
      left: mediaQuery.padding.left + screenPadding,
      right: mediaQuery.padding.right + screenPadding,
    );
  }

  /// Responsive padding based on screen size
  static EdgeInsets responsivePadding(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.width < 600) {
      return screenPaddingAll; // Phone
    } else if (size.width < 840) {
      return const EdgeInsets.all(screenPaddingLarge); // Large phone / Small tablet
    } else {
      return const EdgeInsets.all(xxxl); // Tablet and larger
    }
  }

  /// Responsive horizontal padding
  static EdgeInsets responsiveHorizontalPadding(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.width < 600) {
      return screenPaddingHorizontal; // Phone
    } else if (size.width < 840) {
      return const EdgeInsets.symmetric(horizontal: screenPaddingLarge); // Large phone / Small tablet
    } else {
      return const EdgeInsets.symmetric(horizontal: xxxl); // Tablet and larger
    }
  }

  /// Common SizedBox presets for spacing
  static const SizedBox spaceXS = SizedBox(height: xs, width: xs);
  static const SizedBox spaceSM = SizedBox(height: sm, width: sm);
  static const SizedBox spaceMD = SizedBox(height: md, width: md);
  static const SizedBox spaceLG = SizedBox(height: lg, width: lg);
  static const SizedBox spaceXL = SizedBox(height: xl, width: xl);
  static const SizedBox spaceXXL = SizedBox(height: xxl, width: xxl);
  static const SizedBox spaceXXXL = SizedBox(height: xxxl, width: xxxl);

  /// Vertical spacing
  static const SizedBox verticalSpaceXS = SizedBox(height: xs);
  static const SizedBox verticalSpaceSM = SizedBox(height: sm);
  static const SizedBox verticalSpaceMD = SizedBox(height: md);
  static const SizedBox verticalSpaceLG = SizedBox(height: lg);
  static const SizedBox verticalSpaceXL = SizedBox(height: xl);
  static const SizedBox verticalSpaceXXL = SizedBox(height: xxl);
  static const SizedBox verticalSpaceXXXL = SizedBox(height: xxxl);

  /// Horizontal spacing
  static const SizedBox horizontalSpaceXS = SizedBox(width: xs);
  static const SizedBox horizontalSpaceSM = SizedBox(width: sm);
  static const SizedBox horizontalSpaceMD = SizedBox(width: md);
  static const SizedBox horizontalSpaceLG = SizedBox(width: lg);
  static const SizedBox horizontalSpaceXL = SizedBox(width: xl);
  static const SizedBox horizontalSpaceXXL = SizedBox(width: xxl);
  static const SizedBox horizontalSpaceXXXL = SizedBox(width: xxxl);

  /// Border radius presets
  static BorderRadius radiusXS = BorderRadius.circular(xs);
  static BorderRadius radiusSM = BorderRadius.circular(sm);
  static BorderRadius radiusMD = BorderRadius.circular(md);
  static BorderRadius radiusLG = BorderRadius.circular(lg);
  static BorderRadius radiusXL = BorderRadius.circular(xl);
  static BorderRadius radiusXXL = BorderRadius.circular(xxl);

  /// Component-specific border radius
  static BorderRadius get cardRadius => radiusMD;
  static BorderRadius get buttonRadius => radiusMD;
  static BorderRadius get fieldRadius => radiusSM;
  static BorderRadius get dialogRadius => radiusLG;
  static BorderRadius get sheetRadius => radiusXL;

  /// Animation durations following Material 3
  static const Duration animationFast = Duration(milliseconds: 100);
  static const Duration animationNormal = Duration(milliseconds: 200);
  static const Duration animationSlow = Duration(milliseconds: 300);
  static const Duration animationSlower = Duration(milliseconds: 500);

  /// Elevation values for Material 3
  static const double elevationNone = 0;
  static const double elevationLow = 1;
  static const double elevationMedium = 3;
  static const double elevationHigh = 6;
  static const double elevationHigher = 12;
  static const double elevationHighest = 24;

  /// Icon sizes
  static const double iconXS = 16;
  static const double iconSM = 20;
  static const double iconMD = 24;
  static const double iconLG = 32;
  static const double iconXL = 40;
  static const double iconXXL = 48;

  /// Button heights following Material 3
  static const double buttonHeightSmall = 32;
  static const double buttonHeight = 40;
  static const double buttonHeightLarge = 56;

  /// Minimum touch target size (accessibility)
  static const double minTouchTarget = 48;

  /// Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 840;
  static const double desktopBreakpoint = 1200;

  /// Check if screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Check if screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }
}