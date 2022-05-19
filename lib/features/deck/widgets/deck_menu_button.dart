import 'package:flutter/material.dart';

enum MenuItem { preferences, update, delete }

class DeckMenuButton extends StatelessWidget {
  final Function() onPreferences;
  final Function() onUpdate;
  final Function() onDelete;

  const DeckMenuButton({
    Key? key,
    required this.onPreferences,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value as MenuItem) {
          case MenuItem.preferences:
            onPreferences();
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
          key: Key('deckMenuButton_preferences_popupMenuItem'),
          child: Text('Preferences'),
          value: MenuItem.preferences,
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
