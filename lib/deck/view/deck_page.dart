import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorization_app/deck/deck.dart';
import 'package:memorization_app/l10n/l10n.dart';
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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const _DeckTitle(),
        centerTitle: true,
        actions: [
          const SizedBox(width: 10),
          const _CircleAvatar(),
          DeckMenuButton(
            onEntryLayout: () => EntryLayoutDialog.show(
              context,
              context.read<DeckCubit>().state.deck.entryLayout,
            ).then((value) {
              if (value != null) {
                context.read<DeckCubit>().onLayoutChanged(value);
              }
            }),
            onUpdate: () => Navigator.of(context)
                .push<void>(ManageDeckPage.route(
                  deckIndex: context.read<DeckCubit>().state.deckIndex,
                ))
                .then((_) => context.read<DeckCubit>()
                  ..readDeck(context.read<DeckCubit>().state.deckIndex)),
            onDelete: () => DeleteDeckDialog.show(
              context,
              context.read<DeckCubit>().state.deck.name,
            ).then((value) async {
              if (value != null && value) {
                await context.read<DeckCubit>().deleteDeck();
              }
            }),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<DeckCubit, DeckState>(
          listener: (context, state) {
            if (state.status == DeckStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(l10n.unexpectedError)));
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
                return Center(child: Text(l10n.noEntriesFound));
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
  const _DeckTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = context.select((DeckCubit cubit) => cubit.state.deck.name);
    return Text(name);
  }
}

class _CircleAvatar extends StatelessWidget {
  const _CircleAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = context.select((DeckCubit cubit) => cubit.state.deck.color);
    return CircleAvatar(
      backgroundColor: Color(color),
      child: const Icon(Icons.folder_open),
    );
  }
}
