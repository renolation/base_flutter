import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Main theme configuration with Material 3 design system
class AppTheme {
  // Prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      // Material 3 configuration
      useMaterial3: true,
      colorScheme: AppColors.lightScheme,

      // Typography - Apply theme colors to text styles
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.lightScheme.onSurface,
        displayColor: AppColors.lightScheme.onSurface,
      ),

      // App bar theme
      appBarTheme: _lightAppBarTheme,

      // Card theme
      cardTheme: CardThemeData(
        elevation: AppSpacing.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.cardRadius,
        ),
        margin: const EdgeInsets.all(AppSpacing.cardMargin),
      ),

      // Button themes
      elevatedButtonTheme: _elevatedButtonTheme,
      filledButtonTheme: _filledButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      iconButtonTheme: _iconButtonTheme,
      floatingActionButtonTheme: _lightFabTheme,

      // Input field themes
      inputDecorationTheme: _getInputDecorationTheme(AppColors.lightScheme),

      // Other component themes
      bottomNavigationBarTheme: _lightBottomNavTheme,
      navigationBarTheme: _lightNavigationBarTheme,
      navigationRailTheme: _lightNavigationRailTheme,
      drawerTheme: _lightDrawerTheme,
      dialogTheme: DialogThemeData(
        elevation: AppSpacing.elevationHigher,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.dialogRadius,
        ),
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.lightScheme.onSurface,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightScheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: _bottomSheetTheme,
      snackBarTheme: _getSnackBarTheme(AppColors.lightScheme),
      chipTheme: _lightChipTheme,
      dividerTheme: _dividerTheme,
      listTileTheme: _getListTileTheme(AppColors.lightScheme),
      switchTheme: _lightSwitchTheme,
      checkboxTheme: _lightCheckboxTheme,
      radioTheme: _lightRadioTheme,
      sliderTheme: _lightSliderTheme,
      progressIndicatorTheme: _progressIndicatorTheme,

      // Extensions
      extensions: const [
        AppColorsExtension.light,
      ],

      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Material tap target size
      materialTapTargetSize: MaterialTapTargetSize.padded,

      // Page transitions
      pageTransitionsTheme: _pageTransitionsTheme,

      // Splash factory
      splashFactory: InkRipple.splashFactory,
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      // Material 3 configuration
      useMaterial3: true,
      colorScheme: AppColors.darkScheme,

      // Typography - Apply theme colors to text styles
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.darkScheme.onSurface,
        displayColor: AppColors.darkScheme.onSurface,
      ),

      // App bar theme
      appBarTheme: _darkAppBarTheme,

      // Card theme
      cardTheme: CardThemeData(
        elevation: AppSpacing.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.cardRadius,
        ),
        margin: const EdgeInsets.all(AppSpacing.cardMargin),
      ),

      // Button themes
      elevatedButtonTheme: _elevatedButtonTheme,
      filledButtonTheme: _filledButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      iconButtonTheme: _iconButtonTheme,
      floatingActionButtonTheme: _darkFabTheme,

      // Input field themes
      inputDecorationTheme: _getInputDecorationTheme(AppColors.darkScheme),

      // Other component themes
      bottomNavigationBarTheme: _darkBottomNavTheme,
      navigationBarTheme: _darkNavigationBarTheme,
      navigationRailTheme: _darkNavigationRailTheme,
      drawerTheme: _darkDrawerTheme,
      dialogTheme: DialogThemeData(
        elevation: AppSpacing.elevationHigher,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.dialogRadius,
        ),
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: AppColors.darkScheme.onSurface,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkScheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: _bottomSheetTheme,
      snackBarTheme: _getSnackBarTheme(AppColors.darkScheme),
      chipTheme: _darkChipTheme,
      dividerTheme: _dividerTheme,
      listTileTheme: _getListTileTheme(AppColors.darkScheme),
      switchTheme: _darkSwitchTheme,
      checkboxTheme: _darkCheckboxTheme,
      radioTheme: _darkRadioTheme,
      sliderTheme: _darkSliderTheme,
      progressIndicatorTheme: _progressIndicatorTheme,

      // Extensions
      extensions: const [
        AppColorsExtension.dark,
      ],

      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Material tap target size
      materialTapTargetSize: MaterialTapTargetSize.padded,

      // Page transitions
      pageTransitionsTheme: _pageTransitionsTheme,

      // Splash factory
      splashFactory: InkRipple.splashFactory,
    );
  }

  /// System UI overlay styles
  static const SystemUiOverlayStyle lightSystemUiOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle darkSystemUiOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Color(0xFF121212),
    systemNavigationBarIconBrightness: Brightness.light,
  );

  // Private theme components

  static AppBarTheme get _lightAppBarTheme => const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 1,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.black87,
    centerTitle: false,
    systemOverlayStyle: lightSystemUiOverlay,
    titleTextStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
  );

  static AppBarTheme get _darkAppBarTheme => const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 1,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    centerTitle: false,
    systemOverlayStyle: darkSystemUiOverlay,
    titleTextStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  );

  static ElevatedButtonThemeData get _elevatedButtonTheme => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(0, AppSpacing.buttonHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.buttonPaddingHorizontal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.buttonRadius,
      ),
      textStyle: AppTypography.buttonText,
      elevation: AppSpacing.elevationLow,
    ),
  );

  static FilledButtonThemeData get _filledButtonTheme => FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(0, AppSpacing.buttonHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.buttonPaddingHorizontal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.buttonRadius,
      ),
      textStyle: AppTypography.buttonText,
    ),
  );

  static OutlinedButtonThemeData get _outlinedButtonTheme => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(0, AppSpacing.buttonHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.buttonPaddingHorizontal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.buttonRadius,
      ),
      textStyle: AppTypography.buttonText,
      side: const BorderSide(width: AppSpacing.borderWidth),
    ),
  );

  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: const Size(0, AppSpacing.buttonHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.buttonPaddingHorizontal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.buttonRadius,
      ),
      textStyle: AppTypography.buttonText,
    ),
  );

  static IconButtonThemeData get _iconButtonTheme => IconButtonThemeData(
    style: IconButton.styleFrom(
      minimumSize: const Size(AppSpacing.minTouchTarget, AppSpacing.minTouchTarget),
      iconSize: AppSpacing.iconMD,
    ),
  );

  static FloatingActionButtonThemeData get _lightFabTheme => FloatingActionButtonThemeData(
    elevation: AppSpacing.elevationMedium,
    highlightElevation: AppSpacing.elevationHigh,
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.radiusLG,
    ),
  );

  static FloatingActionButtonThemeData get _darkFabTheme => FloatingActionButtonThemeData(
    elevation: AppSpacing.elevationMedium,
    highlightElevation: AppSpacing.elevationHigh,
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.radiusLG,
    ),
  );

  static InputDecorationTheme _getInputDecorationTheme(ColorScheme colorScheme) => InputDecorationTheme(
    filled: true,
    contentPadding: const EdgeInsets.all(AppSpacing.fieldPadding),
    border: OutlineInputBorder(
      borderRadius: AppSpacing.fieldRadius,
      borderSide: const BorderSide(width: AppSpacing.borderWidth),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppSpacing.fieldRadius,
      borderSide: const BorderSide(width: AppSpacing.borderWidth),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppSpacing.fieldRadius,
      borderSide: const BorderSide(width: AppSpacing.borderWidthThick),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppSpacing.fieldRadius,
      borderSide: const BorderSide(width: AppSpacing.borderWidth),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppSpacing.fieldRadius,
      borderSide: const BorderSide(width: AppSpacing.borderWidthThick),
    ),
    errorStyle: AppTypography.errorText.copyWith(color: colorScheme.error),
    hintStyle: AppTypography.hintText.copyWith(color: colorScheme.onSurfaceVariant),
    labelStyle: AppTypography.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
  );

  static BottomNavigationBarThemeData get _lightBottomNavTheme => BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: AppSpacing.elevationMedium,
    selectedLabelStyle: AppTypography.labelSmall.copyWith(
      color: AppColors.lightScheme.primary,
    ),
    unselectedLabelStyle: AppTypography.labelSmall.copyWith(
      color: AppColors.lightScheme.onSurfaceVariant,
    ),
  );

  static BottomNavigationBarThemeData get _darkBottomNavTheme => BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: AppSpacing.elevationMedium,
    selectedLabelStyle: AppTypography.labelSmall.copyWith(
      color: AppColors.darkScheme.primary,
    ),
    unselectedLabelStyle: AppTypography.labelSmall.copyWith(
      color: AppColors.darkScheme.onSurfaceVariant,
    ),
  );

  static NavigationBarThemeData get _lightNavigationBarTheme => NavigationBarThemeData(
    height: 80,
    elevation: AppSpacing.elevationMedium,
    labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.labelSmall.copyWith(
            color: AppColors.lightScheme.primary,
          );
        }
        return AppTypography.labelSmall.copyWith(
          color: AppColors.lightScheme.onSurfaceVariant,
        );
      },
    ),
  );

  static NavigationBarThemeData get _darkNavigationBarTheme => NavigationBarThemeData(
    height: 80,
    elevation: AppSpacing.elevationMedium,
    labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.labelSmall.copyWith(
            color: AppColors.darkScheme.primary,
          );
        }
        return AppTypography.labelSmall.copyWith(
          color: AppColors.darkScheme.onSurfaceVariant,
        );
      },
    ),
  );

  static NavigationRailThemeData get _lightNavigationRailTheme => const NavigationRailThemeData(
    elevation: AppSpacing.elevationMedium,
    labelType: NavigationRailLabelType.selected,
  );

  static NavigationRailThemeData get _darkNavigationRailTheme => const NavigationRailThemeData(
    elevation: AppSpacing.elevationMedium,
    labelType: NavigationRailLabelType.selected,
  );

  static DrawerThemeData get _lightDrawerTheme => DrawerThemeData(
    elevation: AppSpacing.elevationHigh,
    shape: const RoundedRectangleBorder(),
  );

  static DrawerThemeData get _darkDrawerTheme => DrawerThemeData(
    elevation: AppSpacing.elevationHigh,
    shape: const RoundedRectangleBorder(),
  );

  static BottomSheetThemeData get _bottomSheetTheme => BottomSheetThemeData(
    elevation: AppSpacing.elevationHigh,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppSpacing.sheetRadius.topLeft.x),
        topRight: Radius.circular(AppSpacing.sheetRadius.topRight.x),
      ),
    ),
  );

  static SnackBarThemeData _getSnackBarTheme(ColorScheme colorScheme) => SnackBarThemeData(
    elevation: AppSpacing.elevationMedium,
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.radiusSM,
    ),
    behavior: SnackBarBehavior.floating,
    contentTextStyle: AppTypography.bodyMedium.copyWith(
      color: colorScheme.onInverseSurface,
    ),
  );

  static ChipThemeData get _lightChipTheme => ChipThemeData(
    elevation: AppSpacing.elevationLow,
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.radiusSM,
    ),
    labelStyle: AppTypography.labelMedium.copyWith(
      color: AppColors.lightScheme.onSurfaceVariant,
    ),
  );

  static ChipThemeData get _darkChipTheme => ChipThemeData(
    elevation: AppSpacing.elevationLow,
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.radiusSM,
    ),
    labelStyle: AppTypography.labelMedium.copyWith(
      color: AppColors.darkScheme.onSurfaceVariant,
    ),
  );

  static const DividerThemeData _dividerTheme = DividerThemeData(
    thickness: AppSpacing.borderWidth,
    space: AppSpacing.dividerSpacing,
  );

  static ListTileThemeData _getListTileTheme(ColorScheme colorScheme) => ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.listItemPadding,
      vertical: AppSpacing.listItemMargin,
    ),
    titleTextStyle: AppTypography.titleMedium.copyWith(
      color: colorScheme.onSurface,
    ),
    subtitleTextStyle: AppTypography.bodyMedium.copyWith(
      color: colorScheme.onSurfaceVariant,
    ),
  );

  static SwitchThemeData get _lightSwitchTheme => SwitchThemeData(
    thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
      (Set<WidgetState> states) => null,
    ),
  );

  static SwitchThemeData get _darkSwitchTheme => SwitchThemeData(
    thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
      (Set<WidgetState> states) => null,
    ),
  );

  static CheckboxThemeData get _lightCheckboxTheme => CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.radiusXS,
    ),
  );

  static CheckboxThemeData get _darkCheckboxTheme => CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.radiusXS,
    ),
  );

  static RadioThemeData get _lightRadioTheme => const RadioThemeData();

  static RadioThemeData get _darkRadioTheme => const RadioThemeData();

  static SliderThemeData get _lightSliderTheme => const SliderThemeData(
    trackHeight: 4,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
  );

  static SliderThemeData get _darkSliderTheme => const SliderThemeData(
    trackHeight: 4,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
  );

  static const ProgressIndicatorThemeData _progressIndicatorTheme = ProgressIndicatorThemeData(
    linearTrackColor: Colors.transparent,
  );

  static const PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
    },
  );

  /// Create responsive theme based on screen size
  static ThemeData responsiveTheme(BuildContext context, {required bool isDark}) {
    final baseTheme = isDark ? darkTheme : lightTheme;
    final colorScheme = isDark ? AppColors.darkScheme : AppColors.lightScheme;
    final responsiveTextTheme = AppTypography.responsiveTextTheme(context).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return baseTheme.copyWith(
      textTheme: responsiveTextTheme,
    );
  }

  /// Get appropriate system UI overlay style based on theme
  static SystemUiOverlayStyle getSystemUiOverlayStyle(bool isDark) {
    return isDark ? darkSystemUiOverlay : lightSystemUiOverlay;
  }

  /// Dynamic color scheme support
  static ColorScheme? dynamicLightColorScheme(BuildContext context) {
    try {
      return ColorScheme.fromSeed(
        seedColor: AppColors.lightScheme.primary,
        brightness: Brightness.light,
      );
    } catch (e) {
      return null;
    }
  }

  static ColorScheme? dynamicDarkColorScheme(BuildContext context) {
    try {
      return ColorScheme.fromSeed(
        seedColor: AppColors.darkScheme.primary,
        brightness: Brightness.dark,
      );
    } catch (e) {
      return null;
    }
  }

  /// Create theme with dynamic colors
  static ThemeData createDynamicTheme({
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    final baseTheme = isDark ? darkTheme : lightTheme;
    return baseTheme.copyWith(colorScheme: colorScheme);
  }
}