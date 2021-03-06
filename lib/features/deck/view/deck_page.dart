import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data.dart';
import '../../../repositories/repositories.dart';
import '../../features.dart';

class DeckPage extends StatelessWidget {
  final int deckIndex;

  const DeckPage({
    Key? key,
    required this.deckIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DeckCubit(context.read<DeckRepository>())..readDeck(deckIndex),
      child: const DeckView(),
    );
  }
}

class DeckView extends StatelessWidget {
  const DeckView({Key? key}) : super(key: key);

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
              onPreferences: () => showDialog(
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
                  .push(MaterialPageRoute(
                      builder: (_) => ManageDeckPage(
                            deckIndex:
                                context.read<DeckCubit>().state.deckIndex,
                          )))
                  .then((value) => context.read<DeckCubit>()
                    ..readDeck(context.read<DeckCubit>().state.deckIndex!)),
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
                ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
            if (state.status == DeckStatus.deleteSuccess) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if (state.status == DeckStatus.loadSuccess) {
              if (state.deck.entries.isEmpty) {
                return const Center(child: Text('No entries'));
              }
              return state.deck.entryLayout == EntryLayout.row
                  ? EntryRowList(entries: state.deck.entries)
                  : EntryExpansionList(entries: state.deck.entries);
            }
            return const Center(child: CircularProgressIndicator());
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
