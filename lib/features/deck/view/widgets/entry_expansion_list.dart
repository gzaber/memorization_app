import 'package:flutter/material.dart';

import '../../../../data/data.dart';

class EntryExpansionList extends StatelessWidget {
  final List<Entry> entries;

  const EntryExpansionList({
    Key? key,
    required this.entries,
  }) : super(key: key);

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
                title: Text(entries[index].description),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
