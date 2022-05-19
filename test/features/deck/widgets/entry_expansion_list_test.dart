import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';

void main() {
  group('EntryExpansionList', () {
    final entries = [
      Entry(title: 'title1', description: 'description1'),
      Entry(title: 'title2', description: 'description2'),
    ];

    testWidgets('renders correct widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EntryExpansionList(
              entries: entries,
            ),
          ),
        ),
      );

      expect(find.byType(EntryExpansionList), findsOneWidget);
      expect(find.byType(ExpansionTile), findsNWidgets(2));
    });

    testWidgets('renders correct deck title without description',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EntryExpansionList(
              entries: entries,
            ),
          ),
        ),
      );

      expect(find.text('title1'), findsOneWidget);
      expect(find.text('title2'), findsOneWidget);
      expect(find.text('description1'), findsNothing);
      expect(find.text('description2'), findsNothing);
    });

    testWidgets(
        'renders correct deck title and description when expansion tile tapped',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EntryExpansionList(
              entries: entries,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ExpansionTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ExpansionTile).last);
      await tester.pumpAndSettle();

      expect(find.text('title1'), findsOneWidget);
      expect(find.text('title2'), findsOneWidget);
      expect(find.text('description1'), findsOneWidget);
      expect(find.text('description2'), findsOneWidget);
    });
  });
}
