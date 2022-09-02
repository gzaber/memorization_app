import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    AppTheme appTheme = context.read<SettingsCubit>().state.appTheme;
    AppFontSize appFontSize = context.read<SettingsCubit>().state.appFontSize;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme',
                style: Theme.of(context).textTheme.headline5,
              ),
              RadioListTile<AppTheme>(
                key: const Key('settingsPage_lightTheme_radioListTile'),
                title: const Text('light'),
                value: AppTheme.light,
                groupValue: appTheme,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().updateAppTheme(value!);
                },
              ),
              RadioListTile<AppTheme>(
                key: const Key('settingsPage_darkTheme_radioListTile'),
                title: const Text('dark'),
                value: AppTheme.dark,
                groupValue: appTheme,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().updateAppTheme(value!);
                },
              ),
              Text(
                'Font size',
                style: Theme.of(context).textTheme.headline5,
              ),
              RadioListTile<AppFontSize>(
                key: const Key('settingsPage_smallFont_radioListTile'),
                title: const Text('small'),
                value: AppFontSize.small,
                groupValue: appFontSize,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().updateAppFontSize(value!);
                },
              ),
              RadioListTile<AppFontSize>(
                key: const Key('settingsPage_mediumFont_radioListTile'),
                title: const Text('medium'),
                value: AppFontSize.medium,
                groupValue: appFontSize,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().updateAppFontSize(value!);
                },
              ),
              RadioListTile<AppFontSize>(
                key: const Key('settingsPage_largeFont_radioListTile'),
                title: const Text('large'),
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
