import 'package:bloc_test/bloc_test.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/decks_overview/decks_overview.dart';
import 'package:mockingjay/mockingjay.dart';

extension PumpView on WidgetTester {
  Future<void> pumpDecksOverviewView({
    required DecksOverviewCubit decksOverviewCubit,
  }) {
    return pumpWidget(
      BlocProvider.value(
        value: decksOverviewCubit,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: DecksOverviewView(),
        ),
      ),
    );
  }
}

extension PumpViewMockNav on WidgetTester {
  Future<void> pumpDecksOverviewViewMockNav({
    required DecksOverviewCubit decksOverviewCubit,
    required MockNavigator navigator,
  }) {
    return pumpWidget(
      BlocProvider.value(
        value: decksOverviewCubit,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MockNavigatorProvider(
            navigator: navigator,
            child: const DecksOverviewView(),
          ),
        ),
      ),
    );
  }
}

AppLocalizations get l10n => AppLocalizationsEn();

class MockDecksRepository extends Mock implements DecksRepository {}

class MockDecksOverviewCubit extends MockCubit<DecksOverviewState>
    implements DecksOverviewCubit {}

void main() {
  group('DecksOverviewPage', () {
    late DecksRepository decksRepository;

    setUp(() {
      decksRepository = MockDecksRepository();
      when(() => decksRepository.readAll()).thenAnswer((_) => []);
    });

    testWidgets('renders DecksOverviewView', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: decksRepository,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: DecksOverviewPage(),
          ),
        ),
      );

      expect(find.byType(DecksOverviewView), findsOneWidget);
    });
  });

  group('DecksOverviewView', () {
    late DecksOverviewCubit decksOverviewCubit;
    late MockNavigator navigator;
    const entry1 = Entry(title: 'title1', content: 'content1');
    const entry2 = Entry(title: 'title2', content: 'content2');
    const deck1 = Deck(name: 'deck1', entries: [entry1]);
    const deck2 = Deck(name: 'deck2', entries: [entry1, entry2]);

    setUp(() {
      decksOverviewCubit = MockDecksOverviewCubit();
      navigator = MockNavigator();
      when(() => navigator.push<void>(any())).thenAnswer((_) async {});
    });

    testWidgets('renders CircularProgressIndicator when data is loading',
        (tester) async {
      when(() => decksOverviewCubit.state).thenReturn(
          const DecksOverviewState(status: DecksOverviewStatus.loading));

      await tester.pumpDecksOverviewView(
          decksOverviewCubit: decksOverviewCubit);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders deck cards when data is loaded successfully',
        (tester) async {
      when(() => decksOverviewCubit.state).thenReturn(
        const DecksOverviewState(
            status: DecksOverviewStatus.success, decks: [deck1, deck2]),
      );

      await tester.pumpDecksOverviewView(
          decksOverviewCubit: decksOverviewCubit);

      expect(find.byType(CircleAvatar), findsNWidgets(2));
      expect(find.byIcon(Icons.folder_open), findsNWidgets(2));
      expect(find.text(deck1.name), findsOneWidget);
      expect(find.text(deck2.name), findsOneWidget);
      expect(
          find.text(l10n.entriesNumber(deck1.entries.length)), findsOneWidget);
      expect(
          find.text(l10n.entriesNumber(deck2.entries.length)), findsOneWidget);
    });

    testWidgets('renders text info when no decks found', (tester) async {
      when(() => decksOverviewCubit.state).thenReturn(
        const DecksOverviewState(
            status: DecksOverviewStatus.success, decks: []),
      );

      await tester.pumpDecksOverviewView(
          decksOverviewCubit: decksOverviewCubit);

      expect(find.text(l10n.noDecksFound), findsOneWidget);
    });

    testWidgets('shows SnackBar with message when exception occurs',
        (tester) async {
      when(() => decksOverviewCubit.state).thenReturn(
          const DecksOverviewState(status: DecksOverviewStatus.loading));
      whenListen(
          decksOverviewCubit,
          Stream.fromIterable(
              [const DecksOverviewState(status: DecksOverviewStatus.failure)]));

      await tester.pumpDecksOverviewView(
          decksOverviewCubit: decksOverviewCubit);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.descendant(
            of: find.byType(SnackBar),
            matching: find.text(l10n.unexpectedError)),
        findsOneWidget,
      );
    });

    testWidgets('renders AppBar with title and settings button',
        (tester) async {
      when(() => decksOverviewCubit.state).thenReturn(
        const DecksOverviewState(
            status: DecksOverviewStatus.success, decks: [deck1, deck2]),
      );

      await tester.pumpDecksOverviewView(
          decksOverviewCubit: decksOverviewCubit);

      expect(
        find.descendant(
            of: find.byType(AppBar), matching: find.text(l10n.appName)),
        findsOneWidget,
      );
      expect(
        find.descendant(
            of: find.byType(AppBar), matching: find.byType(IconButton)),
        findsOneWidget,
      );
      expect(
        find.descendant(
            of: find.byType(IconButton), matching: find.byIcon(Icons.settings)),
        findsOneWidget,
      );
    });

    testWidgets('renders FloatingActionButton', (tester) async {
      when(() => decksOverviewCubit.state).thenReturn(
        const DecksOverviewState(
            status: DecksOverviewStatus.success, decks: [deck1, deck2]),
      );

      await tester.pumpDecksOverviewView(
          decksOverviewCubit: decksOverviewCubit);

      expect(
        find.byType(FloatingActionButton),
        findsOneWidget,
      );
    });

    testWidgets('routes to SettingsPage when settings button is tapped',
        (tester) async {
      when(() => decksOverviewCubit.state).thenReturn(
        const DecksOverviewState(
            status: DecksOverviewStatus.success, decks: [deck1, deck2]),
      );

      await tester.pumpDecksOverviewViewMockNav(
          decksOverviewCubit: decksOverviewCubit, navigator: navigator);

      await tester.tap(find.byIcon(Icons.settings));

      verify(
        () => navigator.push<void>(
          any(that: isRoute<void>(whereName: equals('/settings'))),
        ),
      ).called(1);
    });

    testWidgets('routes to ManageDeckPage when FloatingActionButton is tapped',
        (tester) async {
      when(() => decksOverviewCubit.state).thenReturn(
        const DecksOverviewState(
            status: DecksOverviewStatus.success, decks: [deck1, deck2]),
      );

      await tester.pumpDecksOverviewViewMockNav(
          decksOverviewCubit: decksOverviewCubit, navigator: navigator);

      await tester.tap(find.byType(FloatingActionButton));

      verify(
        () => navigator.push<void>(
          any(that: isRoute<void>(whereName: equals('/manage'))),
        ),
      ).called(1);
    });

    testWidgets('routes to DeckPage when deck card is tapped', (tester) async {
      when(() => decksOverviewCubit.state).thenReturn(
        const DecksOverviewState(
            status: DecksOverviewStatus.success, decks: [deck1, deck2]),
      );

      await tester.pumpDecksOverviewViewMockNav(
          decksOverviewCubit: decksOverviewCubit, navigator: navigator);

      await tester.tap(find.text(deck1.name));

      verify(
        () => navigator.push<void>(
          any(that: isRoute<void>(whereName: equals('/deck'))),
        ),
      ).called(1);
    });
  });
}
