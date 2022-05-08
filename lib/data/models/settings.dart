import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 0)
class Settings extends Equatable {
  @HiveField(0)
  final Theme theme;
  @HiveField(1)
  final FontSize fontSize;

  const Settings({
    this.theme = Theme.light,
    this.fontSize = FontSize.medium,
  });

  Settings copyWith({
    Theme? theme,
    FontSize? fontSize,
  }) {
    return Settings(
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  @override
  List<Object?> get props => [theme, fontSize];
}

@HiveType(typeId: 1)
enum Theme {
  @HiveField(0)
  light,
  @HiveField(1)
  dark,
}

@HiveType(typeId: 2)
enum FontSize {
  @HiveField(0)
  small,
  @HiveField(1)
  medium,
  @HiveField(2)
  large,
}
