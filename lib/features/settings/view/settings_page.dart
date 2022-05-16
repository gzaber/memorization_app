import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/data.dart';
import '../settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme _appTheme = context.read<SettingsCubit>().state.appTheme;
    AppFontSize _appFontSize = context.read<SettingsCubit>().state.appFontSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme',
                style: Theme.of(context).textTheme.headline5,
              ),
              RadioListTile<AppTheme>(
                title: const Text('light'),
                value: AppTheme.light,
                groupValue: _appTheme,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().updateAppTheme(value!);
                },
              ),
              RadioListTile<AppTheme>(
                title: const Text('dark'),
                value: AppTheme.dark,
                groupValue: _appTheme,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().updateAppTheme(value!);
                },
              ),
              Text(
                'Font size',
                style: Theme.of(context).textTheme.headline5,
              ),
              RadioListTile<AppFontSize>(
                title: const Text('small'),
                value: AppFontSize.small,
                groupValue: _appFontSize,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().updateAppFontSize(value!);
                },
              ),
              RadioListTile<AppFontSize>(
                title: const Text('standard'),
                value: AppFontSize.standard,
                groupValue: _appFontSize,
                onChanged: (value) async {
                  await context.read<SettingsCubit>().updateAppFontSize(value!);
                },
              ),
              RadioListTile<AppFontSize>(
                title: const Text('large'),
                value: AppFontSize.large,
                groupValue: _appFontSize,
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
