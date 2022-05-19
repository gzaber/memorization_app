import 'package:flutter/material.dart';

import '../../../../data/data.dart';

class EntryLayoutDialog extends StatefulWidget {
  final EntryLayout entryLayout;

  const EntryLayoutDialog({
    Key? key,
    required this.entryLayout,
  }) : super(key: key);

  @override
  State<EntryLayoutDialog> createState() => _EntryLayoutDialogState();
}

class _EntryLayoutDialogState extends State<EntryLayoutDialog> {
  late EntryLayout _layout;

  @override
  void initState() {
    _layout = widget.entryLayout;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Entry layout'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<EntryLayout>(
            key: const Key('entryLayoutDialog_row_radioListTile'),
            title: const Text('row'),
            value: EntryLayout.row,
            groupValue: _layout,
            onChanged: (layout) {
              setState(() {
                _layout = layout!;
              });
            },
          ),
          RadioListTile<EntryLayout>(
            key: const Key('entryLayoutDialog_expansionTile_radioListTile'),
            title: const Text('expand / collapse'),
            value: EntryLayout.expansionTile,
            groupValue: _layout,
            onChanged: (layout) {
              setState(() {
                _layout = layout!;
              });
            },
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        TextButton(
          key: const Key('entryLayoutDialog_cancel_textButton'),
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          key: const Key('entryLayoutDialog_ok_textButton'),
          onPressed: () => Navigator.pop(context, _layout),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
