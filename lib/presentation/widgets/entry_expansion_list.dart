import 'package:flutter/material.dart';

import '../../data/data.dart';

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
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            children: [
              ListTile(
                title: Text(
                  entries[index].description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
