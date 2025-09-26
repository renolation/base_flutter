// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 0;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      version: fields[0] as int,
      themeMode: fields[1] as String,
      locale: fields[2] as String,
      notificationsEnabled: fields[3] as bool,
      analyticsEnabled: fields[4] as bool,
      cacheStrategy: fields[5] as String,
      cacheExpirationHours: fields[6] as int,
      autoUpdateEnabled: fields[7] as bool,
      lastUpdated: fields[8] as DateTime,
      customSettings: (fields[9] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.version)
      ..writeByte(1)
      ..write(obj.themeMode)
      ..writeByte(2)
      ..write(obj.locale)
      ..writeByte(3)
      ..write(obj.notificationsEnabled)
      ..writeByte(4)
      ..write(obj.analyticsEnabled)
      ..writeByte(5)
      ..write(obj.cacheStrategy)
      ..writeByte(6)
      ..write(obj.cacheExpirationHours)
      ..writeByte(7)
      ..write(obj.autoUpdateEnabled)
      ..writeByte(8)
      ..write(obj.lastUpdated)
      ..writeByte(9)
      ..write(obj.customSettings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
