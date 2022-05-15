import 'package:flutter/material.dart';

import '../../../../data/data.dart';
import '../../deck.dart';

class EntryLayoutDialog extends StatefulWidget {
  final DeckCubit deckCubit;
  const EntryLayoutDialog({
    Key? key,
    required this.deckCubit,
  }) : super(key: key);

  @override
  State<EntryLayoutDialog> createState() => _EntryLayoutDialogState();
}

class _EntryLayoutDialogState extends State<EntryLayoutDialog> {
  late EntryLayout _layout;

  @override
  void initState() {
    _layout = widget.deckCubit.state.deck.entryLayout;
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
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.deckCubit.onLayoutChanged(_layout);
            Navigator.pop(context, 'OK');
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
