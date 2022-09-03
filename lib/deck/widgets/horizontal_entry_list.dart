import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';

class HorizontalEntryList extends StatelessWidget {
  const HorizontalEntryList({
    Key? key,
    required this.entries,
  }) : super(key: key);

  final List<Entry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, index) => const Divider(),
      itemBuilder: (_, index) {
        return ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  entries[index].title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                fit: FlexFit.tight,
                child: Text(entries[index].content),
              ),
            ],
          ),
        );
      },
    );
  }
}
