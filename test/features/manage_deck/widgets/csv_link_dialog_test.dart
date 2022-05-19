import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/features/features.dart';

void main() {
  group('CsvLinkDialog', () {
    testWidgets('renders dialog with correct widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: const Text('csv link dialog'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => const CsvLinkDialog(url: 'url'));
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Link to CSV document'), findsOneWidget);
      expect(find.text('url'), findsOneWidget);
      expect(find.text('Download'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should pops and return url string when download button tapped',
        (tester) async {
      late String url;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: const Text('csv link dialog'),
                onPressed: () {
                  showDialog(
                          context: context,
                          builder: (_) => const CsvLinkDialog(url: 'url'))
                      .then((value) => url = value);
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'csv.url');
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('csvLinkDialog_download_textButton')));
      await tester.pumpAndSettle();

      expect(find.text('csv link dialog'), findsOneWidget);
      expect(url, 'csv.url');
    });

    testWidgets('should pops and return null when cancel button tapped',
        (tester) async {
      String? url;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: const Text('csv link dialog'),
                onPressed: () {
                  showDialog(
                          context: context,
                          builder: (_) => const CsvLinkDialog(url: 'url'))
                      .then((value) => url = value);
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'csv.url');
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('csvLinkDialog_cancel_textButton')));
      await tester.pumpAndSettle();

      expect(find.text('csv link dialog'), findsOneWidget);
      expect(url, isNull);
    });
  });
}
