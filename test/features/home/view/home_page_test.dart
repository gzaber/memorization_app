import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';
import 'package:memorization_app/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';

class MockDeckRepository extends Mock implements DeckRepository {}

class MockCsvRepository extends Mock implements CsvRepository {}

class MockHomeCubit extends Mock implements HomeCubit {}

class MockSettingsCubit extends Mock implements SettingsCubit {}

class FakeDeck extends Mock implements Deck {}

void main() {
  group('HomePage', () {
    late DeckRepository deckRepository;

    setUp(() {
      deckRepository = MockDeckRepository();
    });

    testWidgets('renders HomeView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: const MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      expect(find.byType(HomeView), findsOneWidget);
    });
  });

  group('HomeView', () {
    late DeckRepository deckRepository;
    late CsvRepository csvRepository;
    late HomeCubit homeCubit;
    late SettingsCubit settingsCubit;

    setUp(() {
      deckRepository = MockDeckRepository();
      csvRepository = MockCsvRepository();
      homeCubit = MockHomeCubit();
      settingsCubit = MockSettingsCubit();
    });

    setUpAll(() {
      registerFallbackValue(FakeDeck());
    });

    testWidgets('renders CircularProgressIndicator for HomeLoading',
        (tester) async {
      when(() => homeCubit.state).thenReturn(HomeLoading());
      when(() => homeCubit.stream).thenAnswer((_) async* {
        yield HomeLoading();
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: homeCubit..readAllDecks(),
              child: const HomeView(),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders failure text for HomeFailure', (tester) async {
      when(() => homeCubit.readAllDecks()).thenAnswer((_) => Future.value);
      when(() => homeCubit.state).thenReturn(const HomeFailure('error'));
      when(() => homeCubit.stream).thenAnswer((_) async* {
        yield const HomeFailure('error');
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: homeCubit..readAllDecks(),
              child: const HomeView(),
            ),
          ),
        ),
      );

      expect(find.text('error'), findsOneWidget);
    });

    testWidgets('renders text with info for HomeSuccess when no decks found',
        (tester) async {
      when(() => homeCubit.readAllDecks()).thenAnswer((_) => Future.value);
      when(() => homeCubit.state).thenReturn(const HomeSuccess([]));
      when(() => homeCubit.stream).thenAnswer((_) async* {
        yield const HomeSuccess([]);
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: homeCubit..readAllDecks(),
              child: const HomeView(),
            ),
          ),
        ),
      );

      expect(find.text('No decks'), findsOneWidget);
    });

    testWidgets('renders ListView with decks for HomeSuccess when decks found',
        (tester) async {
      List<Deck> decks = [
        const Deck(name: 'name1', url: 'url2'),
        const Deck(name: 'name2', url: '2')
      ];
      when(() => homeCubit.readAllDecks()).thenAnswer((_) => Future.value);
      when(() => homeCubit.state).thenReturn(HomeSuccess(decks));
      when(() => homeCubit.stream).thenAnswer((_) async* {
        yield HomeSuccess(decks);
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: homeCubit..readAllDecks(),
              child: const HomeView(),
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(DeckCard), findsNWidgets(2));
    });

    testWidgets('navigates to SettingsPage when settings icon button is tapped',
        (tester) async {
      when(() => homeCubit.readAllDecks())
          .thenAnswer((_) async => Future.value);
      when(() => homeCubit.state).thenReturn(const HomeSuccess([]));
      when(() => homeCubit.stream).thenAnswer((_) async* {
        yield const HomeSuccess([]);
      });

      when(() => settingsCubit.readSettings())
          .thenAnswer((_) async => Future.value);
      when(() => settingsCubit.state).thenReturn(const Settings());
      when(() => settingsCubit.stream).thenAnswer((_) async* {
        yield const Settings();
      });

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: BlocProvider.value(
            value: settingsCubit..readSettings(),
            child: MaterialApp(
              home: BlocProvider.value(
                value: homeCubit..readAllDecks(),
                child: const HomeView(),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsPage), findsOneWidget);
    });

    testWidgets('navigates to ManageDeckPage when add deck FAB is tapped',
        (tester) async {
      when(() => homeCubit.readAllDecks())
          .thenAnswer((_) async => Future.value);
      when(() => homeCubit.state).thenReturn(const HomeSuccess([]));
      when(() => homeCubit.stream).thenAnswer((_) async* {
        yield const HomeSuccess([]);
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
              value: homeCubit..readAllDecks(),
              child: const HomeView(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(ManageDeckPage), findsOneWidget);
    });

    testWidgets('triggers readAllDecks on ManageDeckPage pop', (tester) async {
      when(() => homeCubit.readAllDecks())
          .thenAnswer((_) async => Future.value);
      when(() => homeCubit.state).thenReturn(const HomeSuccess([]));
      when(() => homeCubit.stream).thenAnswer((_) async* {
        yield const HomeSuccess([]);
      });

      when(() => deckRepository.createDeck(any()))
          .thenAnswer((_) async => Future.value);

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
              value: homeCubit..readAllDecks(),
              child: const HomeView(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const Key('manageDeckPage_name_textField')), 'name');
      await tester.tap(find.byKey(const Key('manageDeckPage_save_iconButton')));
      await tester.pumpAndSettle();

      expect(find.byType(HomeView), findsOneWidget);
      verify(() => homeCubit.readAllDecks()).called(2);
    });

    testWidgets('navigates to DeckPage when deck list item is tapped',
        (tester) async {
      Deck deck = const Deck(name: 'name', url: 'url');

      when(() => homeCubit.readAllDecks()).thenAnswer((_) => Future.value);
      when(() => homeCubit.state).thenReturn(HomeSuccess([deck]));
      when(() => homeCubit.stream).thenAnswer((_) async* {
        yield HomeSuccess([deck]);
      });

      when(() => deckRepository.readDeck(any())).thenAnswer((_) => deck);

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: homeCubit..readAllDecks(),
              child: const HomeView(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DeckCard));
      await tester.pumpAndSettle();
      expect(find.byType(DeckPage), findsOneWidget);
    });

    testWidgets('triggers readAllDecks on DeckPage pop', (tester) async {
      Deck deck = const Deck(name: 'name', url: 'url');

      when(() => homeCubit.readAllDecks()).thenAnswer((_) => Future.value);
      when(() => homeCubit.state).thenReturn(HomeSuccess([deck]));
      when(() => homeCubit.stream).thenAnswer((_) async* {
        yield HomeSuccess([deck]);
      });

      when(() => deckRepository.readDeck(any())).thenAnswer((_) => deck);
      when(() => deckRepository.deleteDeck(any()))
          .thenAnswer((_) async => Future.value);

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: deckRepository,
          child: MaterialApp(
            home: BlocProvider.value(
              value: homeCubit..readAllDecks(),
              child: const HomeView(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DeckCard));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DeckMenuButton));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const Key('deckMenuButton_delete_popupMenuItem')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('deleteDeckDialog_ok_textButton')));
      await tester.pumpAndSettle();

      expect(find.byType(HomeView), findsOneWidget);
      verify(() => homeCubit.readAllDecks()).called(2);
    });
  });
}
