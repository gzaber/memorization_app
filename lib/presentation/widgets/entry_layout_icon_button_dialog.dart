import 'package:flutter/material.dart';

import '../../data/data.dart';

class EntryLayoutIconButtonDialog extends StatelessWidget {
  const EntryLayoutIconButtonDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EntryLayout _entryLayout = EntryLayout.standard;

    return IconButton(
      icon: const Icon(Icons.tune),
      onPressed: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Entry layout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<EntryLayout>(
                title: const Text('standard'),
                value: EntryLayout.standard,
                groupValue: _entryLayout,
                onChanged: (value) {},
              ),
              RadioListTile<EntryLayout>(
                title: const Text('expanded'),
                value: EntryLayout.expanded,
                groupValue: _entryLayout,
                onChanged: (value) {},
              ),
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
