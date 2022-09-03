import 'package:flutter/material.dart';

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
    return AlertDialog(
      title: const Text('Delete'),
      content: Text('Delete "$name" deck?'),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          key: const Key('deleteDeckDialog_cancel_textButton'),
          onPressed: () => Navigator.of(context).pop<bool>(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          key: const Key('deleteDeckDialog_ok_textButton'),
          onPressed: () => Navigator.of(context).pop<bool>(true),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
