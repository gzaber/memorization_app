import 'package:flutter/material.dart';

class DeckPage extends StatelessWidget {
  const DeckPage({Key? key}) : super(key: key);

  static Route route({required int deckIndex}) {
    return MaterialPageRoute(
      builder: (context) => const DeckPage(),
      settings: const RouteSettings(name: '/deck'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
