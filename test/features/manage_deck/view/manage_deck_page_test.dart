import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/features/features.dart';
import 'package:memorization_app/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

class MockCsvRepository extends Mock implements CsvRepository {}

void main() {
  group('ManageDeckPage', () {
    late DeckRepository deckRepository;
    late CsvRepository csvRepository;

    setUp(() {
      deckRepository = MockDeckRepository();
      csvRepository = MockCsvRepository();
    });

    testWidgets('renders ManageDeckForm', (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(
              value: deckRepository,
            ),
            RepositoryProvider.value(
              value: csvRepository,
            ),
          ],
          child: const MaterialApp(
            home: ManageDeckPage(),
          ),
        ),
      );

      expect(find.byType(ManageDeckForm), findsOneWidget);
    });
  });
}
