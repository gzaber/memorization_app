import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:memorization_app/l10n/l10n.dart';

class EntryLayoutDialog extends StatefulWidget {
  const EntryLayoutDialog({
    Key? key,
    required this.entryLayout,
  }) : super(key: key);

  final EntryLayout entryLayout;

  static Future<EntryLayout?> show(
    BuildContext context,
    EntryLayout entryLayout,
  ) {
    return showDialog<EntryLayout>(
      context: context,
      useRootNavigator: false,
      builder: (_) => EntryLayoutDialog(entryLayout: entryLayout),
    );
  }

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
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.entryLayout),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<EntryLayout>(
            key: const Key('entryLayoutDialog_horizontal_radioListTile'),
            title: Text(l10n.horizontal),
            value: EntryLayout.horizontal,
            groupValue: _layout,
            onChanged: (layout) {
              setState(() {
                _layout = layout!;
              });
            },
          ),
          RadioListTile<EntryLayout>(
            key: const Key('entryLayoutDialog_expansion_radioListTile'),
            title: Text(l10n.expandCollapse),
            value: EntryLayout.expansion,
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
          child: Text(l10n.cancel),
        ),
        TextButton(
          key: const Key('entryLayoutDialog_ok_textButton'),
          onPressed: () => Navigator.pop(context, _layout),
          child: Text(l10n.ok),
        ),
      ],
    );
  }
}
