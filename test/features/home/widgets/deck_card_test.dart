import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';

void main() {
  group('DeckCard', () {
    final entry = Entry(title: 'title', description: 'description');
    final deck = Deck(name: 'name', url: 'url', entries: [entry]);

    testWidgets('renders correct icon and text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckCard(
              deck: deck,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.folder_open), findsOneWidget);
      expect(find.text('name'), findsOneWidget);
      expect(find.text('1 entry'), findsOneWidget);
    });
  });
}
