// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 0;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      theme: fields[0] as Theme,
      fontSize: fields[1] as FontSize,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.theme)
      ..writeByte(1)
      ..write(obj.fontSize);
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

class FontSizeAdapter extends TypeAdapter<FontSize> {
  @override
  final int typeId = 1;

  @override
  FontSize read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FontSize.small;
      case 1:
        return FontSize.medium;
      case 2:
        return FontSize.large;
      default:
        return FontSize.small;
    }
  }

  @override
  void write(BinaryWriter writer, FontSize obj) {
    switch (obj) {
      case FontSize.small:
        writer.writeByte(0);
        break;
      case FontSize.medium:
        writer.writeByte(1);
        break;
      case FontSize.large:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FontSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemeAdapter extends TypeAdapter<Theme> {
  @override
  final int typeId = 2;

  @override
  Theme read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Theme.light;
      case 1:
        return Theme.dark;
      default:
        return Theme.light;
    }
  }

  @override
  void write(BinaryWriter writer, Theme obj) {
    switch (obj) {
      case Theme.light:
        writer.writeByte(0);
        break;
      case Theme.dark:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
