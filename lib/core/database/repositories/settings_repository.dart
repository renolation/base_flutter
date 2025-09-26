import 'package:flutter/foundation.dart';
import '../hive_service.dart';
import '../models/app_settings.dart';
import 'package:hive/hive.dart';

/// Repository for managing application settings using Hive
class SettingsRepository {
  /// Safe getter for app settings box - returns null if not initialized
  Box<AppSettings>? get _settingsBox {
    if (!HiveService.isInitialized) {
      debugPrint('⚠️ SettingsRepository: Hive not initialized yet');
      return null;
    }
    try {
      return HiveService.appSettingsBox;
    } catch (e) {
      debugPrint('❌ Error accessing settings box: $e');
      return null;
    }
  }
  static const String _defaultKey = 'app_settings';

  /// Get the current app settings
  AppSettings getSettings() {
    try {
      final box = _settingsBox;
      if (box == null) {
        debugPrint('⚠️ Cannot access settings: Hive not initialized');
        return AppSettings.defaultSettings();
      }
      final settings = box.get(_defaultKey);

      if (settings == null) {
        // Return default settings if none exist
        final defaultSettings = AppSettings.defaultSettings();
        saveSettings(defaultSettings);
        return defaultSettings;
      }

      // Check if settings need migration
      if (settings.version < 1) {
        final migratedSettings = _migrateSettings(settings);
        saveSettings(migratedSettings);
        return migratedSettings;
      }

      return settings;
    } catch (e, stackTrace) {
      debugPrint('Error getting settings: $e');
      debugPrint('Stack trace: $stackTrace');

      // Return default settings on error
      return AppSettings.defaultSettings();
    }
  }

  /// Save app settings
  Future<void> saveSettings(AppSettings settings) async {
    try {
      final box = _settingsBox;
      if (box == null) {
        debugPrint('⚠️ Cannot access settings: Hive not initialized');
        return;
      }
      final updatedSettings = settings.copyWith(lastUpdated: DateTime.now());
      await box.put(_defaultKey, updatedSettings);
      debugPrint('✅ Settings saved successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error saving settings: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Update theme mode
  Future<void> updateThemeMode(String themeMode) async {
    final currentSettings = getSettings();
    final updatedSettings = currentSettings.copyWith(themeMode: themeMode);
    await saveSettings(updatedSettings);
  }

  /// Update locale
  Future<void> updateLocale(String locale) async {
    final currentSettings = getSettings();
    final updatedSettings = currentSettings.copyWith(locale: locale);
    await saveSettings(updatedSettings);
  }

  /// Update notifications enabled
  Future<void> updateNotificationsEnabled(bool enabled) async {
    final currentSettings = getSettings();
    final updatedSettings = currentSettings.copyWith(notificationsEnabled: enabled);
    await saveSettings(updatedSettings);
  }

  /// Update analytics enabled
  Future<void> updateAnalyticsEnabled(bool enabled) async {
    final currentSettings = getSettings();
    final updatedSettings = currentSettings.copyWith(analyticsEnabled: enabled);
    await saveSettings(updatedSettings);
  }

  /// Update cache strategy
  Future<void> updateCacheStrategy(String strategy) async {
    final currentSettings = getSettings();
    final updatedSettings = currentSettings.copyWith(cacheStrategy: strategy);
    await saveSettings(updatedSettings);
  }

  /// Update cache expiration hours
  Future<void> updateCacheExpirationHours(int hours) async {
    final currentSettings = getSettings();
    final updatedSettings = currentSettings.copyWith(cacheExpirationHours: hours);
    await saveSettings(updatedSettings);
  }

  /// Update auto update enabled
  Future<void> updateAutoUpdateEnabled(bool enabled) async {
    final currentSettings = getSettings();
    final updatedSettings = currentSettings.copyWith(autoUpdateEnabled: enabled);
    await saveSettings(updatedSettings);
  }

  /// Set custom setting
  Future<void> setCustomSetting(String key, dynamic value) async {
    final currentSettings = getSettings();
    final updatedSettings = currentSettings.setCustomSetting(key, value);
    await saveSettings(updatedSettings);
  }

  /// Get custom setting
  T? getCustomSetting<T>(String key) {
    final settings = getSettings();
    return settings.getCustomSetting<T>(key);
  }

  /// Remove custom setting
  Future<void> removeCustomSetting(String key) async {
    final currentSettings = getSettings();
    final updatedSettings = currentSettings.removeCustomSetting(key);
    await saveSettings(updatedSettings);
  }

  /// Reset to default settings
  Future<void> resetToDefault() async {
    final defaultSettings = AppSettings.defaultSettings();
    await saveSettings(defaultSettings);
    debugPrint('✅ Settings reset to default');
  }

  /// Export settings to Map (for backup)
  Map<String, dynamic> exportSettings() {
    try {
      final settings = getSettings();
      return settings.toMap();
    } catch (e) {
      debugPrint('❌ Error exporting settings: $e');
      return {};
    }
  }

  /// Import settings from Map (for restore)
  Future<bool> importSettings(Map<String, dynamic> settingsMap) async {
    try {
      final settings = AppSettings.fromMap(settingsMap);
      await saveSettings(settings);
      debugPrint('✅ Settings imported successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error importing settings: $e');
      return false;
    }
  }

  /// Check if settings exist
  bool hasSettings() {
    try {
      final box = _settingsBox;
      if (box == null) {
        debugPrint('⚠️ Cannot access settings: Hive not initialized');
        return false;
      }
      return box.containsKey(_defaultKey);
    } catch (e) {
      debugPrint('❌ Error checking settings existence: $e');
      return false;
    }
  }

  /// Clear all settings (use with caution)
  Future<void> clearSettings() async {
    try {
      final box = _settingsBox;
      if (box == null) {
        debugPrint('⚠️ Cannot access settings: Hive not initialized');
        return;
      }
      await box.delete(_defaultKey);
      debugPrint('✅ Settings cleared');
    } catch (e) {
      debugPrint('❌ Error clearing settings: $e');
      rethrow;
    }
  }

  /// Get settings statistics
  Map<String, dynamic> getSettingsStats() {
    try {
      final settings = getSettings();
      final box = _settingsBox;
      if (box == null) {
        debugPrint('⚠️ Cannot access settings: Hive not initialized');
        return {};
      }

      return {
        'hasCustomSettings': settings.customSettings?.isNotEmpty ?? false,
        'customSettingsCount': settings.customSettings?.length ?? 0,
        'lastUpdated': settings.lastUpdated.toIso8601String(),
        'version': settings.version,
        'settingsAge': DateTime.now().difference(settings.lastUpdated).inDays,
        'isExpired': settings.isExpired(),
        'totalSettingsInBox': box.length,
      };
    } catch (e) {
      debugPrint('❌ Error getting settings stats: $e');
      return {};
    }
  }

  /// Migrate settings from older version
  AppSettings _migrateSettings(AppSettings oldSettings) {
    debugPrint('🔄 Migrating settings from version ${oldSettings.version} to 1');

    // Perform any necessary migrations here
    // For now, just update the version and timestamp
    return oldSettings.copyWith(
      version: 1,
      lastUpdated: DateTime.now(),
    );
  }

  /// Validate settings
  bool validateSettings(AppSettings settings) {
    try {
      // Basic validation
      if (settings.version < 1) return false;
      if (settings.cacheExpirationHours < 1) return false;
      if (!['light', 'dark', 'system'].contains(settings.themeMode)) return false;
      if (!['aggressive', 'normal', 'minimal'].contains(settings.cacheStrategy)) return false;

      return true;
    } catch (e) {
      debugPrint('❌ Error validating settings: $e');
      return false;
    }
  }

  /// Watch settings changes
  Stream<AppSettings> watchSettings() {
    try {
      final box = _settingsBox;
      if (box == null) {
        debugPrint('⚠️ Cannot access settings: Hive not initialized');
        return Stream.value(AppSettings.defaultSettings());
      }
      return box.watch(key: _defaultKey).map((event) {
        final settings = event.value as AppSettings?;
        return settings ?? AppSettings.defaultSettings();
      });
    } catch (e) {
      debugPrint('❌ Error watching settings: $e');
      return Stream.value(AppSettings.defaultSettings());
    }
  }

  /// Compact settings storage
  Future<void> compact() async {
    try {
      final box = _settingsBox;
      if (box == null) {
        debugPrint('⚠️ Cannot access settings: Hive not initialized');
        return;
      }
      await box.compact();
      debugPrint('✅ Settings storage compacted');
    } catch (e) {
      debugPrint('❌ Error compacting settings: $e');
    }
  }
}