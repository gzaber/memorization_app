import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';
import 'package:memorization_app/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

class MockCsvRepository extends Mock implements CsvRepository {}

class MockDeckCubit extends Mock implements DeckCubit {}

class FakeDeck extends Mock implements Deck {}

void main() {
  group('DeckPage', () {
    late DeckRepository deckRepository;

    setUp(() {
      deckRepository = MockDeckRepository();
    });

    testWidgets('renders DeckView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: const MaterialApp(
            home: DeckPage(deckIndex: 0),
          ),
        ),
      );

      expect(find.byType(DeckView), findsOneWidget);
    });
  });

  group('DeckView', () {
    late DeckRepository deckRepository;
    late CsvRepository csvRepository;
    late DeckCubit deckCubit;

    setUp(() {
      deckRepository = MockDeckRepository();
      csvRepository = MockCsvRepository();
      deckCubit = MockDeckCubit();
    });

    setUpAll(() {
      registerFallbackValue(FakeDeck());
    });

    testWidgets('renders CircularProgressIndicator for DeckStatus.loading',
        (tester) async {
      const index = 0;

      when(() => deckCubit.state).thenReturn(const DeckState());
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield const DeckState();
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: deckCubit..readDeck(index),
              child: const DeckView(),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders SnackBar with error text for DeckStatus.failure',
        (tester) async {
      const index = 0;

      when(() => deckCubit.state).thenReturn(
          const DeckState(status: DeckStatus.failure, errorMessage: 'error'));
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield const DeckState(
            status: DeckStatus.failure, errorMessage: 'error');
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: deckCubit..readDeck(index),
              child: Builder(
                builder: (context) => const Scaffold(
                  body: DeckView(),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('error'), findsOneWidget);
    });

    testWidgets(
        'renders text with info for DeckStatus.loadSuccess when no entry exists',
        (tester) async {
      const index = 0;

      when(() => deckCubit.state)
          .thenReturn(const DeckState(status: DeckStatus.loadSuccess));
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield const DeckState(status: DeckStatus.loadSuccess);
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: deckCubit..readDeck(index),
              child: const DeckView(),
            ),
          ),
        ),
      );

      expect(find.text('No entries'), findsOneWidget);
    });

    testWidgets(
        'renders EntryRowList for DeckStatus.loadSuccess when entries exist',
        (tester) async {
      const index = 0;
      final entries = [Entry(title: 'title', description: 'description')];
      final deck = Deck(name: 'name', url: 'url', entries: entries);

      when(() => deckCubit.state)
          .thenReturn(DeckState(status: DeckStatus.loadSuccess, deck: deck));
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield DeckState(status: DeckStatus.loadSuccess, deck: deck);
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: deckCubit..readDeck(index),
              child: const DeckView(),
            ),
          ),
        ),
      );

      expect(find.byType(EntryRowList), findsOneWidget);
    });

    testWidgets(
        'renders EntryExpansionList for DeckStatus.loadSuccess when entries exist',
        (tester) async {
      const index = 0;
      final entries = [Entry(title: 'title', description: 'description')];
      final deck = Deck(
          name: 'name',
          url: 'url',
          entries: entries,
          entryLayout: EntryLayout.expansionTile);

      when(() => deckCubit.state)
          .thenReturn(DeckState(status: DeckStatus.loadSuccess, deck: deck));
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield DeckState(status: DeckStatus.loadSuccess, deck: deck);
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: deckCubit..readDeck(index),
              child: const DeckView(),
            ),
          ),
        ),
      );

      expect(find.byType(EntryExpansionList), findsOneWidget);
    });

    testWidgets('pops for DeckStatus.deleteSuccess', (tester) async {
      const index = 0;

      when(() => deckCubit.state)
          .thenReturn(const DeckState(status: DeckStatus.deleteSuccess));
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield const DeckState(status: DeckStatus.deleteSuccess);
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  child: const Text('go to DeckPage'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                            value: deckCubit..readDeck(index),
                            child: const DeckView())));
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('go to DeckPage'), findsOneWidget);
      verify(() => deckCubit.readDeck(index)).called(1);
    });

    testWidgets('renders deck name', (tester) async {
      const index = 0;
      Deck deck = const Deck(name: 'name', url: 'url');

      when(() => deckCubit.state)
          .thenReturn(DeckState(status: DeckStatus.loadSuccess, deck: deck));
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield DeckState(status: DeckStatus.loadSuccess, deck: deck);
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: deckCubit..readDeck(index),
              child: const DeckView(),
            ),
          ),
        ),
      );

      expect(find.text(deck.name), findsOneWidget);
    });

    testWidgets('renders CircleAvatar with deck color and icon',
        (tester) async {
      const index = 0;
      Deck deck = const Deck(name: 'name', url: 'url', color: 0xff80d8ff);

      when(() => deckCubit.state)
          .thenReturn(DeckState(status: DeckStatus.loadSuccess, deck: deck));
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield DeckState(status: DeckStatus.loadSuccess, deck: deck);
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: deckCubit..readDeck(index),
              child: const DeckView(),
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byIcon(Icons.folder_open), findsOneWidget);
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.backgroundColor, const Color(0xff80d8ff));
    });

    testWidgets('renders menu button', (tester) async {
      const index = 0;

      when(() => deckCubit.state)
          .thenReturn(const DeckState(status: DeckStatus.loadSuccess));
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield const DeckState(status: DeckStatus.loadSuccess);
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: deckCubit..readDeck(index),
              child: const DeckView(),
            ),
          ),
        ),
      );

      expect(find.byType(DeckMenuButton), findsOneWidget);
    });

    testWidgets('renders menu items when menu button tapped', (tester) async {
      const index = 0;

      when(() => deckCubit.state)
          .thenReturn(const DeckState(status: DeckStatus.loadSuccess));
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield const DeckState(status: DeckStatus.loadSuccess);
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: deckCubit..readDeck(index),
              child: const DeckView(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DeckMenuButton));
      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuItem), findsNWidgets(3));
    });

    testWidgets('renders preferences dialog when preferences menu item tapped',
        (tester) async {
      const index = 0;

      when(() => deckCubit.state)
          .thenReturn(const DeckState(status: DeckStatus.loadSuccess));
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield const DeckState(status: DeckStatus.loadSuccess);
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: deckCubit..readDeck(index),
              child: const DeckView(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DeckMenuButton));
      await tester.pumpAndSettle();
      await tester.tap(
          find.byKey(const Key('deckMenuButton_preferences_popupMenuItem')));
      await tester.pumpAndSettle();

      expect(find.byType(EntryLayoutDialog), findsOneWidget);
    });

    testWidgets('navigates to ManageDeckPage when update menu item tapped',
        (tester) async {
      const index = 0;

      when(() => deckCubit.state)
          .thenReturn(const DeckState(status: DeckStatus.loadSuccess));
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield const DeckState(status: DeckStatus.loadSuccess);
      });

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
          child: MaterialApp(
            home: BlocProvider.value(
              value: deckCubit..readDeck(index),
              child: const DeckView(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DeckMenuButton));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('deckMenuButton_update_popupMenuItem')));
      await tester.pumpAndSettle();

      expect(find.byType(ManageDeckPage), findsOneWidget);
    });

    testWidgets('triggers readDeck on ManageDeckPage pop', (tester) async {
      const index = 0;
      Deck deck = const Deck(name: 'name', url: 'url');

      when(() => deckRepository.readDeck(any())).thenAnswer((_) => deck);
      when(() => deckRepository.updateDeck(any(), any()))
          .thenAnswer((_) async => Future.value);
      when(() => deckCubit.state).thenReturn(DeckState(
          status: DeckStatus.loadSuccess, deck: deck, deckIndex: index));
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield DeckState(
            status: DeckStatus.loadSuccess, deck: deck, deckIndex: index);
      });

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
          child: MaterialApp(
            home: BlocProvider.value(
              value: deckCubit..readDeck(index),
              child: const DeckView(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DeckMenuButton));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('deckMenuButton_update_popupMenuItem')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('manageDeckPage_save_iconButton')));
      await tester.pumpAndSettle();

      expect(find.byType(DeckView), findsOneWidget);
      verify(() => deckCubit.readDeck(index)).called(2);
    });

    testWidgets('renders delete deck dialog when delete menu item tapped',
        (tester) async {
      const index = 0;

      when(() => deckCubit.state)
          .thenReturn(const DeckState(status: DeckStatus.loadSuccess));
      when(() => deckCubit.stream).thenAnswer((_) async* {
        yield const DeckState(status: DeckStatus.loadSuccess);
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: deckCubit..readDeck(index),
              child: const DeckView(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DeckMenuButton));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('deckMenuButton_delete_popupMenuItem')));
      await tester.pumpAndSettle();

      expect(find.byType(DeleteDeckDialog), findsOneWidget);
    });
  });
}
