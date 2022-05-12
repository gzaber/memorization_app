import 'package:flutter/material.dart';

import '../../data/data.dart';

class DeckCard extends StatelessWidget {
  final Deck deck;
  final Function() onTap;

  const DeckCard({
    Key? key,
    required this.deck,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.folder),
        title: Text(
          deck.name,
          style: const TextStyle(fontSize: 20.0),
        ),
        subtitle: Text(
          '${deck.entries.length} elements',
          style: const TextStyle(fontSize: 18.0),
        ),
        tileColor: Color(deck.color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
