import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'deck.g.dart';

@HiveType(typeId: 0)
class Deck extends Equatable {
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

  const Deck({
    required this.name,
    required this.url,
    this.color = 0xff334455,
    this.entries = const [],
    this.entryLayout = EntryLayout.standard,
  });

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
class Entry {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;

  Entry({
    required this.title,
    required this.description,
  });
}

@HiveType(typeId: 2)
enum EntryLayout {
  @HiveField(0)
  standard,
  @HiveField(1)
  expanded,
}
