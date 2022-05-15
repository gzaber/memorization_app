// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 3;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      appTheme: fields[0] as AppTheme,
      appFontSize: fields[1] as AppFontSize,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.appTheme)
      ..writeByte(1)
      ..write(obj.appFontSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppThemeAdapter extends TypeAdapter<AppTheme> {
  @override
  final int typeId = 4;

  @override
  AppTheme read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppTheme.light;
      case 1:
        return AppTheme.dark;
      default:
        return AppTheme.light;
    }
  }

  @override
  void write(BinaryWriter writer, AppTheme obj) {
    switch (obj) {
      case AppTheme.light:
        writer.writeByte(0);
        break;
      case AppTheme.dark:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppFontSizeAdapter extends TypeAdapter<AppFontSize> {
  @override
  final int typeId = 5;

  @override
  AppFontSize read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppFontSize.small;
      case 1:
        return AppFontSize.standard;
      case 2:
        return AppFontSize.large;
      default:
        return AppFontSize.small;
    }
  }

  @override
  void write(BinaryWriter writer, AppFontSize obj) {
    switch (obj) {
      case AppFontSize.small:
        writer.writeByte(0);
        break;
      case AppFontSize.standard:
        writer.writeByte(1);
        break;
      case AppFontSize.large:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppFontSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
