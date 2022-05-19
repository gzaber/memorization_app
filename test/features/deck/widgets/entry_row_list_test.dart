import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';

void main() {
  group('EntryRowList', () {
    final entries = [
      Entry(title: 'title1', description: 'description1'),
      Entry(title: 'title2', description: 'description2'),
    ];

    testWidgets('renders correct widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EntryRowList(
              entries: entries,
            ),
          ),
        ),
      );

      expect(find.byType(EntryRowList), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('title1'), findsOneWidget);
      expect(find.text('title2'), findsOneWidget);
      expect(find.text('description1'), findsOneWidget);
      expect(find.text('description2'), findsOneWidget);
    });
  });
}
