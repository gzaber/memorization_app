import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/features/features.dart';

void main() {
  group('DeckMenuButton', () {
    testWidgets('renders correct icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckMenuButton(
              onPreferences: () {},
              onUpdate: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('renders menu items with correct text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeckMenuButton(
              onPreferences: () {},
              onUpdate: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DeckMenuButton));
      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuItem), findsNWidgets(3));
      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('Update'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });
  });
}
