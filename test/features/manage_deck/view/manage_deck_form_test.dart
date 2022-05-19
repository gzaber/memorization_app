import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_app/data/data.dart';
import 'package:memorization_app/features/features.dart';
import 'package:mocktail/mocktail.dart';

class MockManageDeckCubit extends Mock implements ManageDeckCubit {}

void main() {
  group('ManageDeckForm', () {
    late ManageDeckCubit manageDeckCubit;

    setUp(() {
      manageDeckCubit = MockManageDeckCubit();
    });

    testWidgets('renders correct widgets', (tester) async {
      when(() => manageDeckCubit.state).thenReturn(const ManageDeckState());
      when(() => manageDeckCubit.stream).thenAnswer((_) async* {
        yield const ManageDeckState();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: manageDeckCubit..readDeck(),
            child: const ManageDeckForm(),
          ),
        ),
      );

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.folder), findsOneWidget);
      expect(find.byIcon(Icons.link), findsOneWidget);
      expect(find.byIcon(Icons.list), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.text('Deck name'), findsOneWidget);
      expect(find.text('Color'), findsOneWidget);
      expect(find.text('CSV document link'), findsOneWidget);
      expect(find.text('0 entries'), findsOneWidget);
    });

    testWidgets('renders create title when creating new deck', (tester) async {
      when(() => manageDeckCubit.state).thenReturn(const ManageDeckState());
      when(() => manageDeckCubit.stream).thenAnswer((_) async* {
        yield const ManageDeckState();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: manageDeckCubit..readDeck(),
            child: const ManageDeckForm(),
          ),
        ),
      );

      expect(find.text('Create'), findsOneWidget);
    });

    testWidgets('renders update title, name, url when updating existing deck',
        (tester) async {
      const index = 0;
      final entries = [Entry(title: 'title', description: 'description')];
      final deck = Deck(name: 'name', url: 'url', entries: entries);

      when(() => manageDeckCubit.state)
          .thenReturn(ManageDeckState(deckIndex: index, deck: deck));
      when(() => manageDeckCubit.stream).thenAnswer((_) async* {
        yield ManageDeckState(deckIndex: index, deck: deck);
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: manageDeckCubit..readDeck(index: index),
            child: const ManageDeckForm(),
          ),
        ),
      );

      expect(find.text('Update'), findsOneWidget);
      expect(find.text('name'), findsOneWidget);
      expect(find.text('url'), findsOneWidget);
      expect(find.text('1 entry'), findsOneWidget);
    });

    testWidgets(
        'renders CircularProgressIndicator for ManageDeckStatus.loading',
        (tester) async {
      when(() => manageDeckCubit.state)
          .thenReturn(const ManageDeckState(status: ManageDeckStatus.loading));
      when(() => manageDeckCubit.stream).thenAnswer((_) async* {
        yield const ManageDeckState(status: ManageDeckStatus.loading);
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: manageDeckCubit..readDeck(),
            child: const ManageDeckForm(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renders CircularProgressIndicator for ManageDeckStatus.csvLoading',
        (tester) async {
      when(() => manageDeckCubit.state).thenReturn(
          const ManageDeckState(status: ManageDeckStatus.csvLoading));
      when(() => manageDeckCubit.stream).thenAnswer((_) async* {
        yield const ManageDeckState(status: ManageDeckStatus.csvLoading);
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: manageDeckCubit..readDeck(),
            child: const ManageDeckForm(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders SnackBar with error text for ManageDeckStatus.failure',
        (tester) async {
      when(() => manageDeckCubit.state).thenReturn(const ManageDeckState(
          status: ManageDeckStatus.failure, errorMessage: 'error'));
      when(() => manageDeckCubit.stream).thenAnswer((_) async* {
        yield const ManageDeckState(
            status: ManageDeckStatus.failure, errorMessage: 'error');
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: manageDeckCubit..readDeck(),
            child: const ManageDeckForm(),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('error'), findsOneWidget);
    });

    testWidgets(
        'renders SnackBar with error text for ManageDeckStatus.csvFailure',
        (tester) async {
      when(() => manageDeckCubit.state).thenReturn(const ManageDeckState(
          status: ManageDeckStatus.csvFailure, errorMessage: 'csvError'));
      when(() => manageDeckCubit.stream).thenAnswer((_) async* {
        yield const ManageDeckState(
            status: ManageDeckStatus.csvFailure, errorMessage: 'csvError');
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: manageDeckCubit..readDeck(),
            child: const ManageDeckForm(),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('csvError'), findsOneWidget);
    });

    testWidgets('pops for ManageDeckStatus.success', (tester) async {
      when(() => manageDeckCubit.state)
          .thenReturn(const ManageDeckState(status: ManageDeckStatus.success));
      when(() => manageDeckCubit.stream).thenAnswer((_) async* {
        yield const ManageDeckState(status: ManageDeckStatus.success);
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                child: const Text('go to ManageDeckPage'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                          value: manageDeckCubit..readDeck(),
                          child: const ManageDeckForm())));
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('go to ManageDeckPage'), findsOneWidget);
      verify(() => manageDeckCubit.readDeck()).called(1);
    });

    testWidgets('renders CsvLinkDialog when url text field tapped',
        (tester) async {
      when(() => manageDeckCubit.state).thenReturn(const ManageDeckState());
      when(() => manageDeckCubit.stream).thenAnswer((_) async* {
        yield const ManageDeckState();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: manageDeckCubit..readDeck(),
            child: const ManageDeckForm(),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('manageDeckPage_url_textField')));
      await tester.pumpAndSettle();

      expect(find.byType(CsvLinkDialog), findsOneWidget);
    });
  });
}
