import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorization_app/l10n/l10n.dart';
import 'package:memorization_app/settings/settings.dart';
import 'package:settings_repository/settings_repository.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (context) {
        return const SettingsPage();
      },
      settings: const RouteSettings(name: '/settings'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appTheme = context.read<SettingsCubit>().state.appTheme;
    final appFontSize = context.read<SettingsCubit>().state.appFontSize;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.theme,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              RadioListTile<AppTheme>(
                key: const Key('settingsPage_lightTheme_radioListTile'),
                title: Text(l10n.light),
                value: AppTheme.light,
                groupValue: appTheme,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().updateAppTheme(value!);
                },
              ),
              RadioListTile<AppTheme>(
                key: const Key('settingsPage_darkTheme_radioListTile'),
                title: Text(l10n.dark),
                value: AppTheme.dark,
                groupValue: appTheme,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().updateAppTheme(value!);
                },
              ),
              Text(
                l10n.fontSize,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              RadioListTile<AppFontSize>(
                key: const Key('settingsPage_smallFont_radioListTile'),
                title: Text(l10n.small),
                value: AppFontSize.small,
                groupValue: appFontSize,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().updateAppFontSize(value!);
                },
              ),
              RadioListTile<AppFontSize>(
                key: const Key('settingsPage_mediumFont_radioListTile'),
                title: Text(l10n.medium),
                value: AppFontSize.medium,
                groupValue: appFontSize,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().updateAppFontSize(value!);
                },
              ),
              RadioListTile<AppFontSize>(
                key: const Key('settingsPage_largeFont_radioListTile'),
                title: Text(l10n.large),
                value: AppFontSize.large,
                groupValue: appFontSize,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().updateAppFontSize(value!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
