import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 3)
class Settings extends Equatable {
  @HiveField(0)
  final AppTheme appTheme;
  @HiveField(1)
  final AppFontSize appFontSize;

  const Settings({
    this.appTheme = AppTheme.light,
    this.appFontSize = AppFontSize.standard,
  });

  @override
  List<Object?> get props => [appTheme, appFontSize];

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

@HiveType(typeId: 4)
enum AppTheme {
  @HiveField(0)
  light,
  @HiveField(1)
  dark,
}

@HiveType(typeId: 5)
enum AppFontSize {
  @HiveField(0)
  small,
  @HiveField(1)
  standard,
  @HiveField(2)
  large,
}
