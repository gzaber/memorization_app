import 'package:flutter/material.dart';
import 'package:memorization_app/l10n/l10n.dart';

class DeleteDeckDialog extends StatelessWidget {
  const DeleteDeckDialog({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  static Future<bool?> show(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (_) => DeleteDeckDialog(name: name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.delete),
      content: Text(l10n.deleteDeckQuestion(name)),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          key: const Key('deleteDeckDialog_cancel_textButton'),
          onPressed: () => Navigator.of(context).pop<bool>(false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          key: const Key('deleteDeckDialog_ok_textButton'),
          onPressed: () => Navigator.of(context).pop<bool>(true),
          child: Text(l10n.ok),
        ),
      ],
    );
  }
}
