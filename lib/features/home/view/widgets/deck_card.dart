import 'package:flutter/material.dart';

import '../../../../data/data.dart';

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
        leading: CircleAvatar(
          backgroundColor: Color(deck.color),
          child: const Icon(Icons.folder_open),
        ),
        title: Text(
          deck.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text('${deck.entries.length} elements'),
        ),
        minVerticalPadding: 16.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
