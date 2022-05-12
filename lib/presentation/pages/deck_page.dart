import 'package:flutter/material.dart';

import '../../data/data.dart';
import '../widgets/widgets.dart';

class DeckPage extends StatelessWidget {
  const DeckPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DeckView();
  }
}

class DeckView extends StatelessWidget {
  const DeckView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deck'),
        centerTitle: true,
        actions: const [
          EntryLayoutIconButtonDialog(),
          DeckMenuButton(),
        ],
      ),
      body: SafeArea(
        child: EntryListView(entries: entries),
        //EntryExpansionList(entries: entries),
      ),
    );
  }
}

List<Entry> entries = [
  Entry(title: 'title1', description: 'description1'),
  Entry(title: 'title2 sd fs dfsd sd fs df sd', description: 'description2'),
  Entry(title: 'title3', description: 'description3'),
  Entry(title: 'title4', description: 'description4'),
  Entry(
      title: 'title5',
      description:
          'description5dsdfdfs  sdfsdfsdf asdfdf sfsdf sdfsdf sfsdfsd sfsdf\n asdfsfdsf\n asfsadf sdfsdf\n'),
  Entry(title: 'title6', description: 'description6'),
  Entry(title: 'title7', description: 'description7'),
  Entry(title: 'title8', description: 'description8'),
  Entry(title: 'title9', description: 'description9'),
  Entry(title: 'title10', description: 'description10'),
];
