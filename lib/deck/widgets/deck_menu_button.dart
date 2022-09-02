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
          value: MenuItem.entryLayout,
          child: Text('Entry layout'),
        ),
        const PopupMenuItem(
          key: Key('deckMenuButton_update_popupMenuItem'),
          value: MenuItem.update,
          child: Text('Update'),
        ),
        const PopupMenuItem(
          key: Key('deckMenuButton_delete_popupMenuItem'),
          value: MenuItem.delete,
          child: Text('Delete'),
        ),
      ],
    );
  }
}
