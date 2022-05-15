import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/repositories.dart';
import '../../features.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeCubit(context.read<DeckRepository>())..readAllDecks(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MemorizationApp'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const SettingsPage())),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const ManageDeckPage()))
            .then(
              (_) => context.read<HomeCubit>().readAllDecks(),
            ),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeFailure) {
              return Center(
                child: Text(state.message),
              );
            }
            if (state is HomeSuccess) {
              if (state.decks.isEmpty) {
                return const Center(child: Text('No decks'));
              }
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                itemCount: state.decks.length,
                itemBuilder: (context, index) {
                  return DeckCard(
                    deck: state.decks[index],
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (_) => DeckPage(deckIndex: index),
                        ))
                        .then((_) => context.read<HomeCubit>().readAllDecks()),
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
