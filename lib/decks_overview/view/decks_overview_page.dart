import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorization_app/deck/deck.dart';
import 'package:memorization_app/decks_overview/decks_overview.dart';
import 'package:memorization_app/l10n/l10n.dart';
import 'package:memorization_app/manage_deck/manage_deck.dart';
import 'package:memorization_app/settings/settings.dart';

class DecksOverviewPage extends StatelessWidget {
  const DecksOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DecksOverviewCubit(
        decksRepository: context.read<DecksRepository>(),
      )..readAllDecks(),
      child: const DecksOverviewView(),
    );
  }
}

class DecksOverviewView extends StatelessWidget {
  const DecksOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                Navigator.of(context).push<void>(SettingsPage.route()),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context)
              .push<void>(ManageDeckPage.route())
              .then((_) => context.read<DecksOverviewCubit>().readAllDecks())),
      body: SafeArea(
        child: BlocConsumer<DecksOverviewCubit, DecksOverviewState>(
          listener: ((context, state) {
            if (state.status == DecksOverviewStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(l10n.unexpectedError),
                  ),
                );
            }
          }),
          builder: (context, state) {
            if (state.status == DecksOverviewStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == DecksOverviewStatus.success) {
              if (state.decks.isEmpty) {
                return Center(child: Text(l10n.noDecksFound));
              }
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                itemCount: state.decks.length,
                itemBuilder: (context, index) {
                  return DeckCard(
                    deck: state.decks[index],
                    onTap: () => Navigator.of(context)
                        .push<void>(DeckPage.route(deckIndex: index))
                        .then((_) =>
                            context.read<DecksOverviewCubit>().readAllDecks()),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
