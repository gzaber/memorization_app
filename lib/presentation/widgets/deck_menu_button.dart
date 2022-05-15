import 'package:flutter/material.dart';

enum MenuItem { edit, delete }

class DeckMenuButton extends StatelessWidget {
  final Function() onEdit;
  final Function() onDelete;

  const DeckMenuButton({
    Key? key,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value as MenuItem) {
          case MenuItem.edit:
            onEdit();
            break;
          case MenuItem.delete:
            onDelete();
            break;
        }
      },
      itemBuilder: (_) => <PopupMenuEntry>[
        const PopupMenuItem(
          child: Text('Edit'),
          value: MenuItem.edit,
        ),
        const PopupMenuItem(
          child: Text('Delete'),
          value: MenuItem.delete,
        ),
      ],
    );
  }
}
