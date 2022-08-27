import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'deck.g.dart';

@HiveType(typeId: 0)
class Deck extends Equatable {
  const Deck({
    required this.name,
    this.url = '',
    this.color = 0xffff8a80,
    this.entries = const [],
    this.entryLayout = EntryLayout.horizontal,
  });

  @HiveField(0)
  final String name;
  @HiveField(1)
  final String url;
  @HiveField(2)
  final int color;
  @HiveField(3)
  final List<Entry> entries;
  @HiveField(4)
  final EntryLayout entryLayout;

  Deck copyWith({
    String? name,
    String? url,
    int? color,
    List<Entry>? entries,
    EntryLayout? entryLayout,
  }) {
    return Deck(
      name: name ?? this.name,
      url: url ?? this.url,
      color: color ?? this.color,
      entries: entries ?? this.entries,
      entryLayout: entryLayout ?? this.entryLayout,
    );
  }

  @override
  List<Object?> get props => [name, url, color, entries, entryLayout];
}

@HiveType(typeId: 1)
class Entry extends Equatable {
  const Entry({
    required this.title,
    required this.content,
  });

  @HiveField(0)
  final String title;
  @HiveField(1)
  final String content;

  @override
  List<Object> get props => [title, content];
}

@HiveType(typeId: 2)
enum EntryLayout {
  @HiveField(0)
  horizontal,
  @HiveField(1)
  expansion,
}
