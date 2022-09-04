import 'package:bloc_test/bloc_test.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/manage_deck/manage_deck.dart';
import 'package:mocktail/mocktail.dart';

extension PumpForm on WidgetTester {
  Future<void> pumpManageDeckForm({required ManageDeckCubit manageDeckCubit}) {
    return pumpWidget(
      BlocProvider.value(
        value: manageDeckCubit,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ManageDeckPage(),
          ),
        ),
      ),
    );
  }
}

AppLocalizations get l10n => AppLocalizationsEn();

class MockManageDeckCubit extends MockCubit<ManageDeckState>
    implements ManageDeckCubit {}

void main() {
  group('ManageDeckForm', () {
    late ManageDeckCubit manageDeckCubit;

    setUp(() {
      manageDeckCubit = MockManageDeckCubit();
    });

    testWidgets('invokes cubit method when name is changed', (tester) async {
      when(() => manageDeckCubit.state).thenReturn(const ManageDeckState());

      await tester.pumpManageDeckForm(manageDeckCubit: manageDeckCubit);

      await tester.enterText(
          find.byKey(const Key('manageDeckPage_name_textField')), 'name');

      verify(() => manageDeckCubit.onNameChanged('name')).called(1);
    });

    testWidgets('invokes cubit method when color is changed', (tester) async {
      when(() => manageDeckCubit.state).thenReturn(const ManageDeckState());

      await tester.pumpManageDeckForm(manageDeckCubit: manageDeckCubit);

      final container = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((e) => e.color == const Color(0xffea80fc));

      await tester.tap(find.byWidget(container));

      verify(() => manageDeckCubit.onColorChanged(0xffea80fc)).called(1);
    });

    testWidgets('shows AlertDialog when CSV input is tapped', (tester) async {
      when(() => manageDeckCubit.state).thenReturn(const ManageDeckState());

      await tester.pumpManageDeckForm(manageDeckCubit: manageDeckCubit);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.link));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('invokes cubit methods when download button is tapped',
        (tester) async {
      when(() => manageDeckCubit.state).thenReturn(const ManageDeckState());
      when(() => manageDeckCubit.readCsv()).thenAnswer((_) async => {});

      await tester.pumpManageDeckForm(manageDeckCubit: manageDeckCubit);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.link));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const Key('csvLinkDialog_url_textField')), 'url');
      await tester
          .tap(find.byKey(const Key('csvLinkDialog_download_textButton')));
      await tester.pumpAndSettle();

      verify(() => manageDeckCubit.onUrlChanged('url')).called(1);
      verify(() => manageDeckCubit.readCsv()).called(1);
    });

    testWidgets('does not invoke cubit method when cancel button is tapped',
        (tester) async {
      when(() => manageDeckCubit.state).thenReturn(const ManageDeckState());
      when(() => manageDeckCubit.readCsv()).thenAnswer((_) async => {});

      await tester.pumpManageDeckForm(manageDeckCubit: manageDeckCubit);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.link));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const Key('csvLinkDialog_url_textField')), 'url');
      await tester
          .tap(find.byKey(const Key('csvLinkDialog_cancel_textButton')));
      await tester.pumpAndSettle();

      verifyNever(() => manageDeckCubit.onUrlChanged('url'));
      verifyNever(() => manageDeckCubit.readCsv());
    });

    testWidgets('renders CircularProgressIndicator when CSV data is fetching',
        (tester) async {
      when(() => manageDeckCubit.state).thenReturn(
          const ManageDeckState(status: ManageDeckStatus.csvLoading));

      await tester.pumpManageDeckForm(manageDeckCubit: manageDeckCubit);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renders TextField with number of entries when data successfully fetched',
        (tester) async {
      const entry1 = Entry(title: 'title1', content: 'content1');
      const entry2 = Entry(title: 'title2', content: 'content2');
      const deck = Deck(name: 'name', entries: [entry1, entry2]);
      when(() => manageDeckCubit.state).thenReturn(
          const ManageDeckState(status: ManageDeckStatus.initial, deck: deck));

      await tester.pumpManageDeckForm(manageDeckCubit: manageDeckCubit);
      final textField = tester.widget<TextField>(
          find.byKey(const Key('manageDeckPage_entriesNumber_textField')));

      expect(textField.controller!.text, equals(l10n.entriesNumber(2)));
    });

    testWidgets('shows SnackBar with message when exception occurs',
        (tester) async {
      when(() => manageDeckCubit.state).thenReturn(
          const ManageDeckState(status: ManageDeckStatus.csvLoading));
      whenListen(
          manageDeckCubit,
          Stream.fromIterable(
              [const ManageDeckState(status: ManageDeckStatus.csvFailure)]));

      await tester.pumpManageDeckForm(manageDeckCubit: manageDeckCubit);
      await tester.pump();

      expect(
        find.descendant(
            of: find.byType(SnackBar), matching: find.text(l10n.csvFailure)),
        findsOneWidget,
      );
    });
  });
}
