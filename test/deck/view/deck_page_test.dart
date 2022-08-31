import 'package:bloc_test/bloc_test.dart';
import 'package:csv_repository/csv_repository.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/deck/deck.dart';
import 'package:memorization_app/manage_deck/manage_deck.dart';
import 'package:mockingjay/mockingjay.dart';

extension PumpPage on WidgetTester {
  Future<void> pumpDeckPage({required DeckCubit deckCubit}) {
    return pumpWidget(
      BlocProvider.value(
        value: deckCubit,
        child: const MaterialApp(
          home: DeckPage(),
        ),
      ),
    );
  }
}

extension PumpPageMockNav on WidgetTester {
  Future<void> pumpDeckPageMockNav({
    required DeckCubit deckCubit,
    required MockNavigator navigator,
  }) {
    return pumpWidget(
      BlocProvider.value(
        value: deckCubit,
        child: MaterialApp(
          home: MockNavigatorProvider(
              navigator: navigator, child: const DeckPage()),
        ),
      ),
    );
  }
}

extension PumpPageManualNav on WidgetTester {
  Future<void> pumpDeckPageManualNav({
    required DecksRepository decksRepository,
    required CsvRepository csvRepository,
    required DeckCubit deckCubit,
  }) {
    return pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: decksRepository,
          ),
          RepositoryProvider.value(
            value: csvRepository,
          ),
        ],
        child: MaterialApp(
          home: BlocProvider.value(
            value: deckCubit,
            child: const DeckPage(),
          ),
        ),
      ),
    );
  }
}

class MockDecksRepository extends Mock implements DecksRepository {}

class MockCsvRepository extends Mock implements CsvRepository {}

class MockDeckCubit extends MockCubit<DeckState> implements DeckCubit {}

void main() {
  group('DeckPage', () {
    late DecksRepository decksRepository;
    late CsvRepository csvRepository;
    late DeckCubit deckCubit;
    const entry1 = Entry(title: 'title1', content: 'content1');
    const entry2 = Entry(title: 'title2', content: 'content2');
    const deck = Deck(name: 'deck1', entries: [entry1, entry2]);

    setUp(() {
      decksRepository = MockDecksRepository();
      csvRepository = MockCsvRepository();
      deckCubit = MockDeckCubit();

      when(() => deckCubit.onLayoutChanged(any())).thenAnswer((_) async {});
      when(() => deckCubit.deleteDeck()).thenAnswer((_) async {});
    });

    setUpAll(() {
      registerFallbackValue(EntryLayout.horizontal);
    });

    testWidgets('is routable', (tester) async {
      when(() => decksRepository.read(any()))
          .thenAnswer((_) => const Deck(name: 'name'));

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: decksRepository,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(DeckPage.route(deckIndex: 0));
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(DeckPage), findsOneWidget);
    });

    testWidgets('renders CircularProgressIndicator when data is loading',
        (tester) async {
      when(() => deckCubit.state).thenReturn(
          const DeckState(status: DeckStatus.loading, deckIndex: 0));

      await tester.pumpDeckPage(deckCubit: deckCubit);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renders entries with horizontal layout when data loaded successfully',
        (tester) async {
      when(() => deckCubit.state).thenReturn(DeckState(
          status: DeckStatus.loadSuccess,
          deckIndex: 0,
          deck: deck.copyWith(entryLayout: EntryLayout.horizontal)));

      await tester.pumpDeckPage(deckCubit: deckCubit);

      expect(find.byType(HorizontalEntryList), findsOneWidget);
      expect(find.text(entry1.title), findsOneWidget);
      expect(find.text(entry1.content), findsOneWidget);
      expect(find.text(entry2.title), findsOneWidget);
      expect(find.text(entry2.content), findsOneWidget);
    });

    testWidgets(
        'renders entries with expansion layout when data loaded successfully',
        (tester) async {
      when(() => deckCubit.state).thenReturn(DeckState(
          status: DeckStatus.loadSuccess,
          deckIndex: 0,
          deck: deck.copyWith(entryLayout: EntryLayout.expansion)));

      await tester.pumpDeckPage(deckCubit: deckCubit);

      expect(find.byType(ExpansionEntryList), findsOneWidget);
      expect(find.byType(ExpansionTile), findsNWidgets(2));
      expect(find.text(entry1.title), findsOneWidget);
      expect(find.text(entry1.content), findsNothing);
      expect(find.text(entry2.title), findsOneWidget);
      expect(find.text(entry2.content), findsNothing);
    });

    testWidgets('renders text info when no entries found', (tester) async {
      when(() => deckCubit.state).thenReturn(DeckState(
          status: DeckStatus.loadSuccess,
          deckIndex: 0,
          deck: deck.copyWith(entries: [])));

      await tester.pumpDeckPage(deckCubit: deckCubit);

      expect(find.text('No entries'), findsOneWidget);
    });

    testWidgets('shows SnackBar with message when exception occurs',
        (tester) async {
      when(() => deckCubit.state).thenReturn(
          const DeckState(status: DeckStatus.loading, deckIndex: 0));
      whenListen(
          deckCubit,
          Stream.fromIterable(
              [const DeckState(status: DeckStatus.failure, deckIndex: 0)]));

      await tester.pumpDeckPage(deckCubit: deckCubit);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.descendant(
            of: find.byType(SnackBar),
            matching: find.text('Unexpected error occured')),
        findsOneWidget,
      );
    });

    testWidgets('pops when successfully deleted', (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.pop()).thenAnswer((_) async {});
      when(() => deckCubit.state).thenReturn(const DeckState(
          status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck));
      whenListen(
          deckCubit,
          Stream.fromIterable([
            const DeckState(
                status: DeckStatus.deleteSuccess, deckIndex: 0, deck: deck)
          ]));

      await tester.pumpDeckPageMockNav(
          deckCubit: deckCubit, navigator: navigator);

      verify(() => navigator.pop()).called(1);
    });

    testWidgets(
        'renders AppBar with back button, title, CircleAvatar and menu button',
        (tester) async {
      when(() => deckCubit.state).thenReturn(const DeckState(
          status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck));

      await tester.pumpDeckPage(deckCubit: deckCubit);

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
            of: find.byType(AppBar), matching: find.text(deck.name)),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.descendant(
            of: find.byType(CircleAvatar),
            matching: find.byIcon(Icons.folder_open),
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.descendant(
            of: find.byType(PopupMenuButton),
            matching: find.byIcon(Icons.more_vert),
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders menu items when menu button is tapped',
        (tester) async {
      when(() => deckCubit.state).thenReturn(const DeckState(
          status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck));

      await tester.pumpDeckPage(deckCubit: deckCubit);

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuItem), findsNWidgets(3));
      expect(find.text('Entry layout'), findsOneWidget);
      expect(find.text('Update'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets(
        'shows entry layout dialog when entry layout menu item is tapped',
        (tester) async {
      when(() => deckCubit.state).thenReturn(const DeckState(
          status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck));

      await tester.pumpDeckPage(deckCubit: deckCubit);

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();
      await tester.tap(
          find.byKey(const Key('deckMenuButton_entryLayout_popupMenuItem')));
      await tester.pumpAndSettle();

      expect(find.byType(EntryLayoutDialog), findsOneWidget);
    });

    testWidgets(
        'invokes cubit method when changes layout from horizontal to expansion',
        (tester) async {
      when(() => deckCubit.state).thenReturn(const DeckState(
          status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck));

      await tester.pumpDeckPage(deckCubit: deckCubit);

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();
      await tester.tap(
          find.byKey(const Key('deckMenuButton_entryLayout_popupMenuItem')));
      await tester.pumpAndSettle();

      await tester.tap(
          find.byKey(const Key('entryLayoutDialog_expansion_radioListTile')));
      await tester.pump();
      await tester
          .tap(find.byKey(const Key('entryLayoutDialog_ok_textButton')));
      await tester.pumpAndSettle();

      verify(() => deckCubit.onLayoutChanged(EntryLayout.expansion)).called(1);
    });

    testWidgets(
        'invokes cubit method when changes layout from expansion to horizontal',
        (tester) async {
      when(() => deckCubit.state).thenReturn(DeckState(
          status: DeckStatus.loadSuccess,
          deckIndex: 0,
          deck: deck.copyWith(entryLayout: EntryLayout.expansion)));

      await tester.pumpDeckPage(deckCubit: deckCubit);

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();
      await tester.tap(
          find.byKey(const Key('deckMenuButton_entryLayout_popupMenuItem')));
      await tester.pumpAndSettle();

      await tester.tap(
          find.byKey(const Key('entryLayoutDialog_horizontal_radioListTile')));
      await tester.pump();
      await tester
          .tap(find.byKey(const Key('entryLayoutDialog_ok_textButton')));
      await tester.pumpAndSettle();

      verify(() => deckCubit.onLayoutChanged(EntryLayout.horizontal)).called(1);
    });

    testWidgets('does not invoke cubit method when cancels changing layout',
        (tester) async {
      when(() => deckCubit.state).thenReturn(const DeckState(
          status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck));

      await tester.pumpDeckPage(deckCubit: deckCubit);

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();
      await tester.tap(
          find.byKey(const Key('deckMenuButton_entryLayout_popupMenuItem')));
      await tester.pumpAndSettle();

      await tester.tap(
          find.byKey(const Key('entryLayoutDialog_expansion_radioListTile')));
      await tester.pump();
      await tester
          .tap(find.byKey(const Key('entryLayoutDialog_cancel_textButton')));
      await tester.pumpAndSettle();

      verifyNever(() => deckCubit.onLayoutChanged(EntryLayout.expansion));
      verifyNever(() => deckCubit.onLayoutChanged(EntryLayout.horizontal));
    });

    testWidgets('routes to ManageDeckPage when update menu item is tapped',
        (tester) async {
      when(() => deckCubit.state).thenReturn(const DeckState(
          status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck));

      await tester.pumpDeckPageManualNav(
          decksRepository: decksRepository,
          csvRepository: csvRepository,
          deckCubit: deckCubit);

      await tester.tap(find.byType(DeckMenuButton));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('deckMenuButton_update_popupMenuItem')));
      await tester.pumpAndSettle();

      expect(find.byType(ManageDeckPage), findsOneWidget);
    });

    testWidgets('invokes cubit read deck method when pops from ManageDeckPage',
        (tester) async {
      when(() => deckCubit.state).thenReturn(const DeckState(
          status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck));

      await tester.pumpDeckPageManualNav(
          decksRepository: decksRepository,
          csvRepository: csvRepository,
          deckCubit: deckCubit);

      await tester.tap(find.byType(DeckMenuButton));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('deckMenuButton_update_popupMenuItem')));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      verify(() => deckCubit.readDeck(0)).called(1);
    });

    testWidgets('shows delete dialog when delete menu item is tapped',
        (tester) async {
      when(() => deckCubit.state).thenReturn(const DeckState(
          status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck));

      await tester.pumpDeckPage(deckCubit: deckCubit);

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('deckMenuButton_delete_popupMenuItem')));
      await tester.pumpAndSettle();

      expect(find.byType(DeleteDeckDialog), findsOneWidget);
    });

    testWidgets('invokes cubit delete method when confirms deletion',
        (tester) async {
      when(() => deckCubit.state).thenReturn(const DeckState(
          status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck));

      await tester.pumpDeckPage(deckCubit: deckCubit);

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('deckMenuButton_delete_popupMenuItem')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('deleteDeckDialog_ok_textButton')));
      await tester.pumpAndSettle();

      verify(() => deckCubit.deleteDeck()).called(1);
    });

    testWidgets('does not invoke cubit delete method when cancels deletion',
        (tester) async {
      when(() => deckCubit.state).thenReturn(const DeckState(
          status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck));

      await tester.pumpDeckPage(deckCubit: deckCubit);

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('deckMenuButton_delete_popupMenuItem')));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('deleteDeckDialog_cancel_textButton')));
      await tester.pumpAndSettle();

      verifyNever(() => deckCubit.deleteDeck());
    });

    testWidgets('pops when back button is tapped', (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.pop()).thenAnswer((_) async {});
      when(() => deckCubit.state).thenReturn(const DeckState(
          status: DeckStatus.loadSuccess, deckIndex: 0, deck: deck));

      await tester.pumpDeckPageMockNav(
          deckCubit: deckCubit, navigator: navigator);

      await tester.tap(find.byIcon(Icons.arrow_back));

      verify(() => navigator.pop()).called(1);
    });
  });
}
