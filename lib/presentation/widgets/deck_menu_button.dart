import 'package:flutter/material.dart';

class DeckMenuButton extends StatelessWidget {
  const DeckMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) => <PopupMenuEntry>[
        PopupMenuItem(
          child: const Text('Edit'),
          onTap: () {},
        ),
        PopupMenuItem(
          child: const Text('Delete'),
          onTap: () {},
        ),
      ],
    );
  }
}
