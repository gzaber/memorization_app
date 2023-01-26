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
        headlineSmall: baseTheme.textTheme.headlineSmall!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 22
              : appFontSize == AppFontSize.medium
                  ? 24
                  : 28,
          fontWeight: FontWeight.w300,
        ),
        titleLarge: baseTheme.textTheme.titleLarge!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 18
              : appFontSize == AppFontSize.medium
                  ? 20
                  : 24,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: baseTheme.textTheme.labelLarge!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 12
              : appFontSize == AppFontSize.medium
                  ? 14
                  : 18,
        ),
        titleMedium: baseTheme.textTheme.titleMedium!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 14
              : appFontSize == AppFontSize.medium
                  ? 16
                  : 20,
        ),
        bodyMedium: baseTheme.textTheme.bodyMedium!.copyWith(
          fontSize: appFontSize == AppFontSize.small
              ? 12
              : appFontSize == AppFontSize.medium
                  ? 14
                  : 18,
        ),
      ),
    );
  }
}
