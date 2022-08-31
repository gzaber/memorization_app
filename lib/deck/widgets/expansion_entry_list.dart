import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';

class ExpansionEntryList extends StatelessWidget {
  const ExpansionEntryList({
    Key? key,
    required this.entries,
  }) : super(key: key);

  final List<Entry> entries;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          entries.length,
          (index) => ExpansionTile(
            title: Text(
              entries[index].title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            children: [
              ListTile(
                title: Text(entries[index].content),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
