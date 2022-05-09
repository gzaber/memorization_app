import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 0)
class Settings extends Equatable {
  @HiveField(0)
  final AppTheme appTheme;
  @HiveField(1)
  final AppFontSize appFontSize;

  const Settings({
    this.appTheme = AppTheme.light,
    this.appFontSize = AppFontSize.medium,
  });

  @override
  List<Object?> get props => [appTheme, appFontSize];
}

@HiveType(typeId: 1)
enum AppTheme {
  @HiveField(0)
  light,
  @HiveField(1)
  dark,
}

@HiveType(typeId: 2)
enum AppFontSize {
  @HiveField(0)
  small,
  @HiveField(1)
  medium,
  @HiveField(2)
  large,
}
