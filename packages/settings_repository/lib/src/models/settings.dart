import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 10)
class Settings extends Equatable {
  const Settings({
    this.appTheme = AppTheme.light,
    this.appFontSize = AppFontSize.medium,
  });

  @HiveField(0)
  final AppTheme appTheme;
  @HiveField(1)
  final AppFontSize appFontSize;

  @override
  List<Object> get props => [appTheme, appFontSize];

  Settings copyWith({
    AppTheme? appTheme,
    AppFontSize? appFontSize,
  }) {
    return Settings(
      appTheme: appTheme ?? this.appTheme,
      appFontSize: appFontSize ?? this.appFontSize,
    );
  }
}

@HiveType(typeId: 11)
enum AppTheme {
  @HiveField(0)
  light,
  @HiveField(1)
  dark,
}

@HiveType(typeId: 12)
enum AppFontSize {
  @HiveField(0)
  small,
  @HiveField(1)
  medium,
  @HiveField(2)
  large,
}
