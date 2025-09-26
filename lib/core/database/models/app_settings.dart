import 'package:hive/hive.dart';

part 'app_settings.g.dart';

/// App settings model for storing application-wide configuration
@HiveType(typeId: 0)
class AppSettings extends HiveObject {
  @HiveField(0)
  final int version;

  @HiveField(1)
  final String themeMode; // 'light', 'dark', 'system'

  @HiveField(2)
  final String locale; // Language code (e.g., 'en', 'es')

  @HiveField(3)
  final bool notificationsEnabled;

  @HiveField(4)
  final bool analyticsEnabled;

  @HiveField(5)
  final String cacheStrategy; // 'aggressive', 'normal', 'minimal'

  @HiveField(6)
  final int cacheExpirationHours;

  @HiveField(7)
  final bool autoUpdateEnabled;

  @HiveField(8)
  final DateTime lastUpdated;

  @HiveField(9)
  final Map<String, dynamic>? customSettings;

  AppSettings({
    this.version = 1,
    this.themeMode = 'system',
    this.locale = 'en',
    this.notificationsEnabled = true,
    this.analyticsEnabled = false,
    this.cacheStrategy = 'normal',
    this.cacheExpirationHours = 24,
    this.autoUpdateEnabled = true,
    required this.lastUpdated,
    this.customSettings,
  });

  /// Create a copy with modified fields
  AppSettings copyWith({
    int? version,
    String? themeMode,
    String? locale,
    bool? notificationsEnabled,
    bool? analyticsEnabled,
    String? cacheStrategy,
    int? cacheExpirationHours,
    bool? autoUpdateEnabled,
    DateTime? lastUpdated,
    Map<String, dynamic>? customSettings,
  }) {
    return AppSettings(
      version: version ?? this.version,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      cacheStrategy: cacheStrategy ?? this.cacheStrategy,
      cacheExpirationHours: cacheExpirationHours ?? this.cacheExpirationHours,
      autoUpdateEnabled: autoUpdateEnabled ?? this.autoUpdateEnabled,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      customSettings: customSettings ?? this.customSettings,
    );
  }

  /// Create default app settings
  factory AppSettings.defaultSettings() {
    return AppSettings(
      version: 1,
      themeMode: 'system',
      locale: 'en',
      notificationsEnabled: true,
      analyticsEnabled: false,
      cacheStrategy: 'normal',
      cacheExpirationHours: 24,
      autoUpdateEnabled: true,
      lastUpdated: DateTime.now(),
    );
  }

  /// Convert to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'themeMode': themeMode,
      'locale': locale,
      'notificationsEnabled': notificationsEnabled,
      'analyticsEnabled': analyticsEnabled,
      'cacheStrategy': cacheStrategy,
      'cacheExpirationHours': cacheExpirationHours,
      'autoUpdateEnabled': autoUpdateEnabled,
      'lastUpdated': lastUpdated.toIso8601String(),
      'customSettings': customSettings,
    };
  }

  /// Create from Map for JSON deserialization
  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      version: map['version'] ?? 1,
      themeMode: map['themeMode'] ?? 'system',
      locale: map['locale'] ?? 'en',
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      analyticsEnabled: map['analyticsEnabled'] ?? false,
      cacheStrategy: map['cacheStrategy'] ?? 'normal',
      cacheExpirationHours: map['cacheExpirationHours'] ?? 24,
      autoUpdateEnabled: map['autoUpdateEnabled'] ?? true,
      lastUpdated: DateTime.parse(map['lastUpdated'] ?? DateTime.now().toIso8601String()),
      customSettings: map['customSettings']?.cast<String, dynamic>(),
    );
  }

  /// Check if settings are expired (for auto-refresh logic)
  bool isExpired({int maxAgeHours = 168}) { // Default 1 week
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    return difference.inHours > maxAgeHours;
  }

  /// Get custom setting value
  T? getCustomSetting<T>(String key) {
    return customSettings?[key] as T?;
  }

  /// Set custom setting value
  AppSettings setCustomSetting(String key, dynamic value) {
    final updatedCustomSettings = Map<String, dynamic>.from(customSettings ?? {});
    updatedCustomSettings[key] = value;

    return copyWith(
      customSettings: updatedCustomSettings,
      lastUpdated: DateTime.now(),
    );
  }

  /// Remove custom setting
  AppSettings removeCustomSetting(String key) {
    if (customSettings == null) return this;

    final updatedCustomSettings = Map<String, dynamic>.from(customSettings!);
    updatedCustomSettings.remove(key);

    return copyWith(
      customSettings: updatedCustomSettings.isNotEmpty ? updatedCustomSettings : null,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'AppSettings{version: $version, themeMode: $themeMode, locale: $locale, '
           'notificationsEnabled: $notificationsEnabled, analyticsEnabled: $analyticsEnabled, '
           'cacheStrategy: $cacheStrategy, cacheExpirationHours: $cacheExpirationHours, '
           'autoUpdateEnabled: $autoUpdateEnabled, lastUpdated: $lastUpdated, '
           'customSettings: $customSettings}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppSettings &&
        other.version == version &&
        other.themeMode == themeMode &&
        other.locale == locale &&
        other.notificationsEnabled == notificationsEnabled &&
        other.analyticsEnabled == analyticsEnabled &&
        other.cacheStrategy == cacheStrategy &&
        other.cacheExpirationHours == cacheExpirationHours &&
        other.autoUpdateEnabled == autoUpdateEnabled &&
        other.lastUpdated == lastUpdated &&
        _mapEquals(other.customSettings, customSettings);
  }

  bool _mapEquals(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null) return b == null;
    if (b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      version,
      themeMode,
      locale,
      notificationsEnabled,
      analyticsEnabled,
      cacheStrategy,
      cacheExpirationHours,
      autoUpdateEnabled,
      lastUpdated,
      customSettings?.hashCode ?? 0,
    );
  }
}