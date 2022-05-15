import 'package:flutter/material.dart';

import '../../data/data.dart';

class EntryListView extends StatelessWidget {
  final List<Entry> entries;

  const EntryListView({
    Key? key,
    required this.entries,
  }) : super(key: key);

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
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 10.0),
              Flexible(
                fit: FlexFit.tight,
                child: Text(entries[index].description,
                    style: Theme.of(context).textTheme.bodyText2),
              ),
            ],
          ),
        );
      },
    );
  }
}
