import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';

void main() {
  group('EntryLayoutDialog', () {
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
                      builder: (_) => const EntryLayoutDialog(
                            entryLayout: EntryLayout.row,
                          ));
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      final radioRow = tester.widget<RadioListTile>(
          find.byKey(const Key('entryLayoutDialog_row_radioListTile')));
      final radioExpansionTile = tester.widget<RadioListTile>(find
          .byKey(const Key('entryLayoutDialog_expansionTile_radioListTile')));

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(RadioListTile<EntryLayout>), findsNWidgets(2));
      expect(radioRow.checked, true);
      expect(radioExpansionTile.checked, false);
      expect(find.text('Entry layout'), findsOneWidget);
      expect(find.text('row'), findsOneWidget);
      expect(find.text('expand / collapse'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('checks radio when tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: const Text('delete deck'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => const EntryLayoutDialog(
                            entryLayout: EntryLayout.row,
                          ));
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      await tester.tap(find
          .byKey(const Key('entryLayoutDialog_expansionTile_radioListTile')));
      await tester.pumpAndSettle();

      final radioRow = tester.widget<RadioListTile>(
          find.byKey(const Key('entryLayoutDialog_row_radioListTile')));
      final radioExpansionTile = tester.widget<RadioListTile>(find
          .byKey(const Key('entryLayoutDialog_expansionTile_radioListTile')));

      expect(radioRow.checked, false);
      expect(radioExpansionTile.checked, true);
    });

    testWidgets('should pops and return entry layout when ok button tapped',
        (tester) async {
      EntryLayout? layout;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: const Text('delete deck'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => const EntryLayoutDialog(
                            entryLayout: EntryLayout.row,
                          )).then((value) => layout = value);
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      await tester.tap(find
          .byKey(const Key('entryLayoutDialog_expansionTile_radioListTile')));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('entryLayoutDialog_ok_textButton')));
      await tester.pumpAndSettle();

      expect(layout, EntryLayout.expansionTile);
    });

    testWidgets('should pops and return null when cancel button tapped',
        (tester) async {
      EntryLayout? layout;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: const Text('delete deck'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => const EntryLayoutDialog(
                            entryLayout: EntryLayout.row,
                          )).then((value) => layout = value);
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('entryLayoutDialog_cancel_textButton')));
      await tester.pumpAndSettle();

      expect(layout, null);
    });
  });
}
