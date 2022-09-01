import 'package:csv_repository/csv_repository.dart';
import 'package:decks_repository/decks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorization_app/manage_deck/manage_deck.dart';

class ManageDeckPage extends StatelessWidget {
  const ManageDeckPage({Key? key}) : super(key: key);

  static Route route({int? deckIndex}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ManageDeckCubit(
          csvRepository: context.read<CsvRepository>(),
          decksRepository: context.read<DecksRepository>(),
        )..readDeck(index: deckIndex),
        child: const ManageDeckPage(),
      ),
      settings: const RouteSettings(name: '/manage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.read<ManageDeckCubit>().state.deckIndex == null
              ? 'Create'
              : 'Update',
        ),
        centerTitle: true,
        actions: const [_SaveDeckIcon()],
      ),
      body: const SafeArea(
        child: ManageDeckForm(),
      ),
    );
  }
}

class _SaveDeckIcon extends StatelessWidget {
  const _SaveDeckIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageDeckCubit, ManageDeckState>(
      listener: (context, state) {
        if (state.status == ManageDeckStatus.failure) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Unexpected error occured')));
        }
        if (state.status == ManageDeckStatus.saveSuccess) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state.status == ManageDeckStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        return IconButton(
          key: const Key('manageDeckPage_save_iconButton'),
          icon: const Icon(Icons.check),
          onPressed: () async {
            if (context.read<ManageDeckCubit>().state.deckIndex == null) {
              await context.read<ManageDeckCubit>().createDeck();
            } else {
              await context.read<ManageDeckCubit>().updateDeck();
            }
          },
        );
      },
    );
  }
}
