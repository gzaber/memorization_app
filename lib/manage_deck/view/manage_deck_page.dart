import 'package:flutter/material.dart';

class ManageDeckPage extends StatelessWidget {
  const ManageDeckPage({Key? key}) : super(key: key);

  static Route route({int? deckIndex}) {
    return MaterialPageRoute(
      builder: (context) => const ManageDeckPage(),
      settings: const RouteSettings(name: '/manage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
