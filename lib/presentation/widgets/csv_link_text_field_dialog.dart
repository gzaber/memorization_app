import 'package:flutter/material.dart';

class CsvLinkTextFieldDialog extends StatelessWidget {
  const CsvLinkTextFieldDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: const InputDecoration(
        icon: Icon(Icons.link),
        border: OutlineInputBorder(),
      ),
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Link to CSV document'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              TextField(),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
