// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeckAdapter extends TypeAdapter<Deck> {
  @override
  final int typeId = 0;

  @override
  Deck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Deck(
      name: fields[0] as String,
      url: fields[1] as String,
      color: fields[2] as int,
      entries: (fields[3] as List).cast<Entry>(),
      entryLayout: fields[4] as EntryLayout,
    );
  }

  @override
  void write(BinaryWriter writer, Deck obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.entries)
      ..writeByte(4)
      ..write(obj.entryLayout);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EntryAdapter extends TypeAdapter<Entry> {
  @override
  final int typeId = 1;

  @override
  Entry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Entry(
      title: fields[0] as String,
      description: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Entry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EntryLayoutAdapter extends TypeAdapter<EntryLayout> {
  @override
  final int typeId = 2;

  @override
  EntryLayout read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EntryLayout.standard;
      case 1:
        return EntryLayout.expanded;
      default:
        return EntryLayout.standard;
    }
  }

  @override
  void write(BinaryWriter writer, EntryLayout obj) {
    switch (obj) {
      case EntryLayout.standard:
        writer.writeByte(0);
        break;
      case EntryLayout.expanded:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryLayoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
