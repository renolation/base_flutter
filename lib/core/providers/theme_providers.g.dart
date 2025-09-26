// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsRepositoryHash() =>
    r'0203e31bb994214ce864bf95a7afa14a8a14b812';

/// Settings repository provider
///
/// Copied from [settingsRepository].
@ProviderFor(settingsRepository)
final settingsRepositoryProvider =
    AutoDisposeProvider<SettingsRepository>.internal(
  settingsRepository,
  name: r'settingsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SettingsRepositoryRef = AutoDisposeProviderRef<SettingsRepository>;
String _$currentThemeModeHash() => r'6cd4101e1d0f6cbd7851f117872cd49253fe0564';

/// Current theme mode provider
///
/// Copied from [currentThemeMode].
@ProviderFor(currentThemeMode)
final currentThemeModeProvider = AutoDisposeProvider<AppThemeMode>.internal(
  currentThemeMode,
  name: r'currentThemeModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentThemeModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentThemeModeRef = AutoDisposeProviderRef<AppThemeMode>;
String _$effectiveThemeModeHash() =>
    r'd747fdd8489857c595ae766ee6a9497c4ad360c0';

/// Effective theme mode provider (resolves system theme)
///
/// Copied from [effectiveThemeMode].
@ProviderFor(effectiveThemeMode)
final effectiveThemeModeProvider = AutoDisposeProvider<ThemeMode>.internal(
  effectiveThemeMode,
  name: r'effectiveThemeModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$effectiveThemeModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EffectiveThemeModeRef = AutoDisposeProviderRef<ThemeMode>;
String _$isDarkModeHash() => r'e76c5818694a33e63bd0a8ba0b7494d7ee12cff5';

/// Is dark mode active provider
///
/// Copied from [isDarkMode].
@ProviderFor(isDarkMode)
final isDarkModeProvider = AutoDisposeProvider<bool>.internal(
  isDarkMode,
  name: r'isDarkModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isDarkModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsDarkModeRef = AutoDisposeProviderRef<bool>;
String _$currentLocaleHash() => r'c3cb4000a5eefa748ca41e50818b27323e61605a';

/// Current locale provider
///
/// Copied from [currentLocale].
@ProviderFor(currentLocale)
final currentLocaleProvider = AutoDisposeProvider<Locale>.internal(
  currentLocale,
  name: r'currentLocaleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentLocaleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentLocaleRef = AutoDisposeProviderRef<Locale>;
String _$appSettingsNotifierHash() =>
    r'3a66de82c9b8f75bf34ffc7755b145a6d1e9c21e';

/// Current app settings provider
///
/// Copied from [AppSettingsNotifier].
@ProviderFor(AppSettingsNotifier)
final appSettingsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AppSettingsNotifier, AppSettings>.internal(
  AppSettingsNotifier.new,
  name: r'appSettingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appSettingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppSettingsNotifier = AutoDisposeAsyncNotifier<AppSettings>;
String _$settingsStreamNotifierHash() =>
    r'1c1e31439ee63edc3217a20c0198bbb2aff6e033';

/// Settings stream provider for reactive updates
///
/// Copied from [SettingsStreamNotifier].
@ProviderFor(SettingsStreamNotifier)
final settingsStreamNotifierProvider = AutoDisposeStreamNotifierProvider<
    SettingsStreamNotifier, AppSettings>.internal(
  SettingsStreamNotifier.new,
  name: r'settingsStreamNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsStreamNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingsStreamNotifier = AutoDisposeStreamNotifier<AppSettings>;
String _$themePreferencesHash() => r'71778e4afc614e1566d4a15131e2ab5d2302e57b';

/// Theme preferences provider for quick access
///
/// Copied from [ThemePreferences].
@ProviderFor(ThemePreferences)
final themePreferencesProvider = AutoDisposeNotifierProvider<ThemePreferences,
    Map<String, dynamic>>.internal(
  ThemePreferences.new,
  name: r'themePreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themePreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemePreferences = AutoDisposeNotifier<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
