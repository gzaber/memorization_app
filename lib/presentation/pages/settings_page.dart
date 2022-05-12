import 'package:flutter/material.dart';
import '../../data/data.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme _appTheme = AppTheme.light;
    AppFontSize _appFontSize = AppFontSize.medium;

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
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 22.0, fontWeight: FontWeight.w400),
              ),
              RadioListTile<AppTheme>(
                title: const Text('light'),
                value: AppTheme.light,
                groupValue: _appTheme,
                onChanged: (value) {},
              ),
              RadioListTile<AppTheme>(
                title: const Text('dark'),
                value: AppTheme.dark,
                groupValue: _appTheme,
                onChanged: (value) {},
              ),
              Text(
                'Font size',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 22.0, fontWeight: FontWeight.w400),
              ),
              RadioListTile<AppFontSize>(
                title: const Text('small'),
                value: AppFontSize.small,
                groupValue: _appFontSize,
                onChanged: (value) {},
              ),
              RadioListTile<AppFontSize>(
                title: const Text('medium'),
                value: AppFontSize.medium,
                groupValue: _appFontSize,
                onChanged: (value) {},
              ),
              RadioListTile<AppFontSize>(
                title: const Text('large'),
                value: AppFontSize.large,
                groupValue: _appFontSize,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
