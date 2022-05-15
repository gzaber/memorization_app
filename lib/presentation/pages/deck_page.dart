import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data.dart';
import '../../repositories/repositories.dart';
import '../../state_management/state_management.dart';
import '../widgets/widgets.dart';
import 'pages.dart';

class DeckPage extends StatelessWidget {
  final int deckIndex;

  const DeckPage({
    Key? key,
    required this.deckIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeckCubit(
        context.read<DeckRepository>(),
      )..readDeck(deckIndex),
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
        title: BlocBuilder<DeckCubit, DeckState>(
          builder: (context, state) {
            return Text(context.read<DeckCubit>().state.deck.name);
          },
        ),
        centerTitle: false,
        actions: [
          BlocBuilder<DeckCubit, DeckState>(
            builder: (context, state) {
              return CircleAvatar(
                backgroundColor:
                    Color(context.read<DeckCubit>().state.deck.color),
                child: const Text('D'),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => EntryLayoutDialog(
                deckCubit: context.read<DeckCubit>(),
              ),
            ),
          ),
          DeckMenuButton(
            onEdit: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => ManageDeckPage(
                            deckIndex:
                                context.read<DeckCubit>().state.deckIndex,
                          )))
                  .then((value) => context.read<DeckCubit>()
                    ..readDeck(context.read<DeckCubit>().state.deckIndex!));
            },
            onDelete: () {
              showDialog(
                context: context,
                builder: (_) => const DeleteDeckDialog(),
              ).then((value) {
                if (value) {
                  context.read<DeckCubit>().deleteDeck();
                }
              });
            },
          ),
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const HomePage()));
            }
          },
          builder: (context, state) {
            if (state.status == DeckStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == DeckStatus.loadSuccess) {
              if (state.deck.entries.isEmpty) {
                return const Center(
                  child: Text('No entries'),
                );
              }
              return state.deck.entryLayout == EntryLayout.standard
                  ? EntryListView(entries: state.deck.entries)
                  : EntryExpansionList(entries: state.deck.entries);
            }
            return const Center(child: Text('No entries'));
          },
        ),
        //
      ),
    );
  }
}
