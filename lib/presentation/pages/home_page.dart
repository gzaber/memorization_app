import 'package:flutter/material.dart';

import '../../data/data.dart';
import '../widgets/widgets.dart';
import 'pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MemorizationApp'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const ManageDeckPage()));
        },
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          itemCount: decks.length,
          itemBuilder: (context, index) {
            return DeckCard(
              deck: decks[index],
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const DeckPage()));
              },
            );
          },
        ),
      ),
    );
  }
}

const List<Deck> decks = [
  Deck(
    name: 'deck1',
    url: 'url',
    color: 0xffff8a80,
    entries: [],
    entryLayout: EntryLayout.expanded,
  ),
  Deck(
    name: 'deck2',
    url: 'url',
    color: 0xffff80ab,
    entries: [],
    entryLayout: EntryLayout.expanded,
  ),
  Deck(
    name: 'deck3',
    url: 'url',
    color: 0xffea80fc,
    entries: [],
    entryLayout: EntryLayout.expanded,
  ),
  Deck(
    name: 'deck4',
    url: 'url',
    color: 0xffb388ff,
    entries: [],
    entryLayout: EntryLayout.expanded,
  ),
  Deck(
    name: 'deck5',
    url: 'url',
    color: 0xff8c9eff,
    entries: [],
    entryLayout: EntryLayout.expanded,
  ),
  Deck(
    name: 'deck6',
    url: 'url',
    color: 0xff82b1ff,
    entries: [],
    entryLayout: EntryLayout.expanded,
  ),
  Deck(
    name: 'deck7',
    url: 'url',
    color: 0xff80d8ff,
    entries: [],
    entryLayout: EntryLayout.expanded,
  ),
  Deck(
    name: 'deck8',
    url: 'url',
    color: 0xff84ffff,
    entries: [],
    entryLayout: EntryLayout.expanded,
  ),
  Deck(
    name: 'deck9',
    url: 'url',
    color: 0xffa7ffeb,
    entries: [],
    entryLayout: EntryLayout.expanded,
  ),
  Deck(
    name: 'deck10',
    url: 'url',
    color: 0xffb9f6ca,
    entries: [],
    entryLayout: EntryLayout.expanded,
  ),
];
