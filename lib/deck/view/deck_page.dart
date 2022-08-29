import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorization_app/deck/deck.dart';
import 'package:memorization_app/manage_deck/manage_deck.dart';

class DeckPage extends StatelessWidget {
  const DeckPage({Key? key}) : super(key: key);

  static Route route({required int deckIndex}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => DeckCubit(
          decksRepository: context.read<DecksRepository>(),
          deckIndex: deckIndex,
        )..readDeck(deckIndex),
        child: const DeckPage(),
      ),
      settings: const RouteSettings(name: '/deck'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _DeckTitle(),
        centerTitle: true,
        actions: [
          const SizedBox(width: 10.0),
          const _CircleAvatar(),
          DeckMenuButton(
              onEntryLayout: () => showDialog(
                    context: context,
                    builder: (_) => EntryLayoutDialog(
                      entryLayout:
                          context.read<DeckCubit>().state.deck.entryLayout,
                    ),
                  ).then((value) {
                    if (value != null) {
                      context.read<DeckCubit>().onLayoutChanged(value);
                    }
                  }),
              onUpdate: () => Navigator.of(context)
                  .push(ManageDeckPage.route(
                    deckIndex: context.read<DeckCubit>().state.deckIndex,
                  ))
                  .then((value) => context.read<DeckCubit>()
                    ..readDeck(context.read<DeckCubit>().state.deckIndex)),
              onDelete: () => showDialog(
                      context: context,
                      builder: (_) => DeleteDeckDialog(
                            name: context.read<DeckCubit>().state.deck.name,
                          )).then((value) async {
                    if (value) {
                      await context.read<DeckCubit>().deleteDeck();
                    }
                  })),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<DeckCubit, DeckState>(
          listener: (context, state) {
            if (state.status == DeckStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('Unexpected error occured')));
            }
            if (state.status == DeckStatus.deleteSuccess) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if (state.status == DeckStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == DeckStatus.loadSuccess) {
              if (state.deck.entries.isEmpty) {
                return const Center(child: Text('No entries'));
              }
              return state.deck.entryLayout == EntryLayout.horizontal
                  ? HorizontalEntryList(entries: state.deck.entries)
                  : ExpansionEntryList(entries: state.deck.entries);
            }
            return const SizedBox();
          },
        ),
        //
      ),
    );
  }
}

class _DeckTitle extends StatelessWidget {
  const _DeckTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeckCubit, DeckState>(
      builder: (context, state) {
        return Text(context.read<DeckCubit>().state.deck.name);
      },
    );
  }
}

class _CircleAvatar extends StatelessWidget {
  const _CircleAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeckCubit, DeckState>(
      builder: (context, state) {
        return CircleAvatar(
          backgroundColor: Color(context.read<DeckCubit>().state.deck.color),
          child: const Icon(Icons.folder_open),
        );
      },
    );
  }
}
