# Material 3 Theme System

A comprehensive Material 3 (Material You) design system implementation for Flutter applications.

## Overview

This theme system provides:

- **Complete Material 3 design system** with proper color schemes, typography, and spacing
- **Dynamic color support** for Material You theming
- **Light and dark theme configurations** with accessibility-compliant colors
- **Responsive typography** that scales based on screen size
- **Consistent spacing system** following Material Design guidelines
- **Custom component themes** for buttons, cards, inputs, and more
- **Theme switching widgets** with smooth animations

## Quick Start

### 1. Import the theme system

```dart
import 'package:base_flutter/core/theme/theme.dart';
```

### 2. Apply themes to your app

```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      // ... rest of your app
    );
  }
}
```

### 3. Add theme switching capability

```dart
// Simple toggle button
ThemeToggleIconButton()

// Segmented control
ThemeModeSwitch(
  style: ThemeSwitchStyle.segmented,
  showLabel: true,
)

// Animated switch
AnimatedThemeModeSwitch()
```

## Components

### AppTheme
Main theme configuration class containing Material 3 light and dark themes.

```dart
// Get themes
ThemeData lightTheme = AppTheme.lightTheme;
ThemeData darkTheme = AppTheme.darkTheme;

// Responsive theme
ThemeData responsiveTheme = AppTheme.responsiveTheme(context, isDark: false);

// Dynamic colors (Material You)
ColorScheme? dynamicLight = AppTheme.dynamicLightColorScheme(context);
ThemeData dynamicTheme = AppTheme.createDynamicTheme(
  colorScheme: dynamicLight!,
  isDark: false,
);
```

### AppColors
Material 3 color system with semantic colors.

```dart
// Color schemes
ColorScheme lightScheme = AppColors.lightScheme;
ColorScheme darkScheme = AppColors.darkScheme;

// Semantic colors
Color success = AppColors.success;
Color warning = AppColors.warning;
Color info = AppColors.info;

// Surface colors with elevation
Color elevatedSurface = AppColors.getSurfaceColor(2, false);

// Accessibility check
bool isAccessible = AppColors.isAccessible(backgroundColor, textColor);
```

### AppTypography
Material 3 typography system with responsive scaling.

```dart
// Typography styles
TextStyle displayLarge = AppTypography.displayLarge;
TextStyle headlineMedium = AppTypography.headlineMedium;
TextStyle bodyLarge = AppTypography.bodyLarge;

// Responsive typography
TextTheme responsiveTheme = AppTypography.responsiveTextTheme(context);

// Semantic text styles
TextStyle errorStyle = AppTypography.error(context);
TextStyle successStyle = AppTypography.success(context);
```

### AppSpacing
Consistent spacing system based on Material Design grid.

```dart
// Spacing values
double small = AppSpacing.sm;      // 8dp
double medium = AppSpacing.md;     // 12dp
double large = AppSpacing.lg;      // 16dp

// EdgeInsets presets
EdgeInsets padding = AppSpacing.paddingLG;
EdgeInsets screenPadding = AppSpacing.screenPaddingAll;

// SizedBox presets
SizedBox verticalSpace = AppSpacing.verticalSpaceMD;
SizedBox horizontalSpace = AppSpacing.horizontalSpaceLG;

// Responsive padding
EdgeInsets responsivePadding = AppSpacing.responsivePadding(context);

// Border radius
BorderRadius cardRadius = AppSpacing.cardRadius;
BorderRadius buttonRadius = AppSpacing.buttonRadius;

// Screen size checks
bool isMobile = AppSpacing.isMobile(context);
bool isTablet = AppSpacing.isTablet(context);
```

## Theme Extensions

### AppColorsExtension
Additional semantic colors not covered by Material 3 ColorScheme.

```dart
// Access theme extension
final colors = Theme.of(context).extension<AppColorsExtension>();

// Use semantic colors
Color successColor = colors?.success ?? Colors.green;
Color warningColor = colors?.warning ?? Colors.orange;
Color infoColor = colors?.info ?? Colors.blue;
```

## Usage Examples

### Using Colors
```dart
Container(
  color: Theme.of(context).colorScheme.primaryContainer,
  child: Text(
    'Hello World',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    ),
  ),
)
```

### Using Typography
```dart
Column(
  children: [
    Text('Headline', style: Theme.of(context).textTheme.headlineMedium),
    AppSpacing.verticalSpaceSM,
    Text('Body text', style: Theme.of(context).textTheme.bodyLarge),
  ],
)
```

### Using Spacing
```dart
Padding(
  padding: AppSpacing.responsivePadding(context),
  child: Column(
    children: [
      Card(),
      AppSpacing.verticalSpaceLG,
      ElevatedButton(),
    ],
  ),
)
```

### Theme-aware Widgets
```dart
class ThemedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Card Title',
              style: theme.textTheme.titleMedium,
            ),
            AppSpacing.verticalSpaceSM,
            Text(
              'Card content that adapts to the current theme.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
```

## Features

### ✅ Material 3 Design System
- Complete Material 3 color roles and palettes
- Proper elevation handling with surface tints
- Accessibility-compliant color combinations
- Support for dynamic colors (Material You)

### ✅ Responsive Design
- Typography that scales based on screen size
- Responsive padding and margins
- Adaptive layouts for mobile, tablet, and desktop
- Screen size utilities and breakpoints

### ✅ Theme Management
- State management integration with Riverpod
- Theme mode persistence support
- Smooth theme transitions
- Multiple theme switching UI options

### ✅ Developer Experience
- Type-safe theme access
- Consistent spacing system
- Semantic color names
- Comprehensive documentation

## Customization

### Custom Colors
```dart
// Extend AppColors for your brand colors
class BrandColors extends AppColors {
  static const Color brandPrimary = Color(0xFF1976D2);
  static const Color brandSecondary = Color(0xFF0288D1);
}
```

### Custom Typography
```dart
// Override typography for custom fonts
class CustomTypography extends AppTypography {
  static const String fontFamily = 'CustomFont';

  static TextStyle get customStyle => const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}
```

### Theme Showcase

See `theme_showcase.dart` for a comprehensive demo of all theme components and how they work together.

---

This theme system provides a solid foundation for building beautiful, consistent Flutter applications that follow Material 3 design principles while remaining flexible and customizable for your specific needs.