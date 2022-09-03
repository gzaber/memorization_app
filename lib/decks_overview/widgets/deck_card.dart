import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:memorization_app/l10n/l10n.dart';

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
    final l10n = context.l10n;
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.entriesNumber(deck.entries.length)),
        ),
        minVerticalPadding: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
