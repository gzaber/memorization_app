import 'package:flutter/material.dart';
import 'package:settings_repository/settings_repository.dart';

class AppThemeData {
  static ThemeData getTheme({
    required AppTheme appTheme,
    required AppFontSize appFontSize,
  }) {
    final ThemeData baseTheme =
        appTheme == AppTheme.light ? ThemeData.light() : ThemeData.dark();

    return baseTheme.copyWith(
      textTheme: TextTheme(
        headline5: baseTheme.textTheme.headline5!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 22.0
              : appFontSize == AppFontSize.medium
                  ? 24.0
                  : 28.0,
          fontWeight: FontWeight.w300,
        ),
        headline6: baseTheme.textTheme.headline6!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 18.0
              : appFontSize == AppFontSize.medium
                  ? 20.0
                  : 24.0,
          fontWeight: FontWeight.w400,
        ),
        button: baseTheme.textTheme.button!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 12.0
              : appFontSize == AppFontSize.medium
                  ? 14.0
                  : 18.0,
        ),
        subtitle1: baseTheme.textTheme.subtitle1!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 14.0
              : appFontSize == AppFontSize.medium
                  ? 16.0
                  : 20.0,
        ),
        bodyText2: baseTheme.textTheme.bodyText2!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 12.0
              : appFontSize == AppFontSize.medium
                  ? 14.0
                  : 18.0,
        ),
      ),
    );
  }
}
