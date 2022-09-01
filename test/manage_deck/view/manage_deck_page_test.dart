import 'package:bloc_test/bloc_test.dart';
import 'package:csv_repository/csv_repository.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/manage_deck/manage_deck.dart';
import 'package:mockingjay/mockingjay.dart';

class MockCsvRepository extends Mock implements CsvRepository {}

class MockDecksRepository extends Mock implements DecksRepository {}

class MockManageDeckCubit extends MockCubit<ManageDeckState>
    implements ManageDeckCubit {}

void main() {
  late CsvRepository csvRepository;
  late DecksRepository decksRepository;
  late ManageDeckCubit manageDeckCubit;

  setUp(() {
    csvRepository = MockCsvRepository();
    decksRepository = MockDecksRepository();
    manageDeckCubit = MockManageDeckCubit();
  });
  group('ManageDeckPage', () {
    testWidgets('is routable', (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: csvRepository),
            RepositoryProvider.value(value: decksRepository),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(ManageDeckPage.route());
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(ManageDeckPage), findsOneWidget);
    });

    // renders AppBar with right title when creating deck
    // renders AppBar with right title when updating deck
    // renders AppBar with back button and save button
    // pops when back button is tapped
    // creates deck when save button is tapped
    // updates deck when save button is tapped
    // renders CircularProgressIndicator in place save icon when saving deck
    // pops when deck successfully saved
    // shows SnackBar when exception occured
  });
}
