import 'package:flutter/material.dart';

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
        const PopupMenuItem(
          key: Key('deckMenuButton_entryLayout_popupMenuItem'),
          child: Text('Entry layout'),
          value: MenuItem.entryLayout,
        ),
        const PopupMenuItem(
          key: Key('deckMenuButton_update_popupMenuItem'),
          child: Text('Update'),
          value: MenuItem.update,
        ),
        const PopupMenuItem(
          key: Key('deckMenuButton_delete_popupMenuItem'),
          child: Text('Delete'),
          value: MenuItem.delete,
        ),
      ],
    );
  }
}
