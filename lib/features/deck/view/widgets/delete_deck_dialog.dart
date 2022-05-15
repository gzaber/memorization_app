import 'package:flutter/material.dart';

class DeleteDeckDialog extends StatelessWidget {
  const DeleteDeckDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete'),
      content: const Text('Delete deck?'),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop<bool>(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop<bool>(context, true),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
