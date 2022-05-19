import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/features/features.dart';

void main() {
  group('DeleteDeckDialog', () {
    testWidgets('renders dialog with correct widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: const Text('delete deck'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => const DeleteDeckDialog(
                            name: 'deckName',
                          ));
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byType(DeleteDeckDialog), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Delete "deckName" deck?'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should pops and return true when ok button tapped',
        (tester) async {
      late bool result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: const Text('delete deck'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => const DeleteDeckDialog(
                            name: 'deckName',
                          )).then((value) => result = value);
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('deleteDeckDialog_ok_textButton')));
      await tester.pumpAndSettle();

      expect(result, true);
    });

    testWidgets('should pops and return false when cancel button tapped',
        (tester) async {
      late bool result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: const Text('delete deck'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => const DeleteDeckDialog(
                            name: 'deckName',
                          )).then((value) => result = value);
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('deleteDeckDialog_cancel_textButton')));
      await tester.pumpAndSettle();

      expect(result, false);
    });
  });
}
