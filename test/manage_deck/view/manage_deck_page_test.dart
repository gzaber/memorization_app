import 'package:bloc_test/bloc_test.dart';
import 'package:csv_repository/csv_repository.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/manage_deck/manage_deck.dart';
import 'package:mockingjay/mockingjay.dart';

extension PumpPage on WidgetTester {
  Future<void> pumpManageDeckPage({required ManageDeckCubit manageDeckCubit}) {
    return pumpWidget(
      BlocProvider.value(
        value: manageDeckCubit,
        child: const MaterialApp(
          home: ManageDeckPage(),
        ),
      ),
    );
  }
}

extension PumpPageMockNav on WidgetTester {
  Future<void> pumpManageDeckPageMockNav({
    required ManageDeckCubit manageDeckCubit,
    required MockNavigator navigator,
  }) {
    return pumpWidget(
      BlocProvider.value(
        value: manageDeckCubit,
        child: MaterialApp(
          home: MockNavigatorProvider(
            navigator: navigator,
            child: const ManageDeckPage(),
          ),
        ),
      ),
    );
  }
}

class MockCsvRepository extends Mock implements CsvRepository {}

class MockDecksRepository extends Mock implements DecksRepository {}

class MockManageDeckCubit extends MockCubit<ManageDeckState>
    implements ManageDeckCubit {}

void main() {
  late CsvRepository csvRepository;
  late DecksRepository decksRepository;
  late ManageDeckCubit manageDeckCubit;
  final navigator = MockNavigator();

  setUp(() {
    csvRepository = MockCsvRepository();
    decksRepository = MockDecksRepository();
    manageDeckCubit = MockManageDeckCubit();

    when(() => navigator.pop()).thenAnswer((_) async {});
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

    testWidgets('renders AppBar with right title when creating deck',
        (tester) async {
      when(() => manageDeckCubit.state)
          .thenReturn(const ManageDeckState(deckIndex: null));

      await tester.pumpManageDeckPage(manageDeckCubit: manageDeckCubit);

      expect(
        find.descendant(of: find.byType(AppBar), matching: find.text('Create')),
        findsOneWidget,
      );
    });

    testWidgets('renders AppBar with right title when updating deck',
        (tester) async {
      when(() => manageDeckCubit.state)
          .thenReturn(const ManageDeckState(deckIndex: 0));

      await tester.pumpManageDeckPage(manageDeckCubit: manageDeckCubit);

      expect(
        find.descendant(of: find.byType(AppBar), matching: find.text('Update')),
        findsOneWidget,
      );
    });

    testWidgets('renders AppBar with back button and save button',
        (tester) async {
      when(() => manageDeckCubit.state).thenReturn(const ManageDeckState());

      await tester.pumpManageDeckPage(manageDeckCubit: manageDeckCubit);

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.descendant(
            of: find.byType(IconButton),
            matching: find.byIcon(Icons.arrow_back),
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.descendant(
            of: find.byType(IconButton),
            matching: find.byIcon(Icons.check),
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('pops when back button is tapped', (tester) async {
      when(() => manageDeckCubit.state).thenReturn(const ManageDeckState());

      await tester.pumpManageDeckPageMockNav(
          manageDeckCubit: manageDeckCubit, navigator: navigator);

      await tester.tap(find.byIcon(Icons.arrow_back));

      verify(() => navigator.pop()).called(1);
    });

    testWidgets('creates deck when save button is tapped', (tester) async {
      const deck = Deck(name: 'deck');
      when(() => manageDeckCubit.state)
          .thenReturn(const ManageDeckState(deckIndex: null, deck: deck));
      when(() => manageDeckCubit.createDeck()).thenAnswer((_) async => {});

      await tester.pumpManageDeckPage(manageDeckCubit: manageDeckCubit);

      await tester.tap(find.byIcon(Icons.check));

      verify(() => manageDeckCubit.createDeck()).called(1);
    });

    testWidgets('updates deck when save button is tapped', (tester) async {
      const deck = Deck(name: 'deck');
      when(() => manageDeckCubit.state)
          .thenReturn(const ManageDeckState(deckIndex: 0, deck: deck));
      when(() => manageDeckCubit.updateDeck()).thenAnswer((_) async => {});

      await tester.pumpManageDeckPage(manageDeckCubit: manageDeckCubit);

      await tester.tap(find.byIcon(Icons.check));

      verify(() => manageDeckCubit.updateDeck()).called(1);
    });

    testWidgets(
        'renders CircularProgressIndicator in place save icon when saving deck',
        (tester) async {
      const deck = Deck(name: 'deck');
      when(() => manageDeckCubit.state).thenReturn(const ManageDeckState(
          status: ManageDeckStatus.loading, deckIndex: null, deck: deck));

      await tester.pumpManageDeckPage(manageDeckCubit: manageDeckCubit);

      expect(
        find.descendant(
            of: find.byType(AppBar),
            matching: find.byType(CircularProgressIndicator)),
        findsOneWidget,
      );
    });

    testWidgets('pops when deck successfully saved', (tester) async {
      when(() => manageDeckCubit.state)
          .thenReturn(const ManageDeckState(status: ManageDeckStatus.loading));
      whenListen(
          manageDeckCubit,
          Stream.fromIterable(
              [const ManageDeckState(status: ManageDeckStatus.saveSuccess)]));

      await tester.pumpManageDeckPageMockNav(
          manageDeckCubit: manageDeckCubit, navigator: navigator);

      verify(() => navigator.pop()).called(1);
    });

    testWidgets('shows SnackBar when exception occured', (tester) async {
      when(() => manageDeckCubit.state)
          .thenReturn(const ManageDeckState(status: ManageDeckStatus.loading));
      whenListen(
          manageDeckCubit,
          Stream.fromIterable(
              [const ManageDeckState(status: ManageDeckStatus.failure)]));

      await tester.pumpManageDeckPage(manageDeckCubit: manageDeckCubit);
      await tester.pump();

      expect(
        find.descendant(
            of: find.byType(SnackBar),
            matching: find.text('Unexpected error occured')),
        findsOneWidget,
      );
    });

    testWidgets('shows SnackBar when name TextField is empty', (tester) async {
      when(() => manageDeckCubit.state)
          .thenReturn(const ManageDeckState(status: ManageDeckStatus.loading));
      whenListen(
          manageDeckCubit,
          Stream.fromIterable(
              [const ManageDeckState(status: ManageDeckStatus.emptyName)]));

      await tester.pumpManageDeckPage(manageDeckCubit: manageDeckCubit);
      await tester.pump();

      expect(
        find.descendant(
            of: find.byType(SnackBar),
            matching: find.text('Name cannot be empty')),
        findsOneWidget,
      );
    });
  });
}
