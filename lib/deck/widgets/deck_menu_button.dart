import 'package:flutter/material.dart';
import 'package:memorization_app/l10n/l10n.dart';

enum MenuItem { entryLayout, update, delete }

class DeckMenuButton extends StatelessWidget {
  const DeckMenuButton({
    Key? key,
    required this.onEntryLayout,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  final Function() onEntryLayout;
  final Function() onUpdate;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value as MenuItem) {
          case MenuItem.entryLayout:
            onEntryLayout();
            break;
          case MenuItem.update:
            onUpdate();
            break;
          case MenuItem.delete:
            onDelete();
            break;
        }
      },
      itemBuilder: (_) => <PopupMenuEntry>[
        PopupMenuItem(
          key: const Key('deckMenuButton_entryLayout_popupMenuItem'),
          value: MenuItem.entryLayout,
          child: Text(l10n.entryLayout),
        ),
        PopupMenuItem(
          key: const Key('deckMenuButton_update_popupMenuItem'),
          value: MenuItem.update,
          child: Text(l10n.update),
        ),
        PopupMenuItem(
          key: const Key('deckMenuButton_delete_popupMenuItem'),
          value: MenuItem.delete,
          child: Text(l10n.delete),
        ),
      ],
    );
  }
}
