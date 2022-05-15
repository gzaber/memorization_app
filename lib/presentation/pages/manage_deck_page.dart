import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';
import '../../state_management/state_management.dart';
import '../widgets/widgets.dart';

class ManageDeckPage extends StatelessWidget {
  final int? deckIndex;

  const ManageDeckPage({
    Key? key,
    this.deckIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageDeckCubit(
        context.read<DeckRepository>(),
        context.read<CsvRepository>(),
      )..readDeck(index: deckIndex),
      child: const ManageDeckView(),
    );
  }
}

class ManageDeckView extends StatelessWidget {
  const ManageDeckView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.read<ManageDeckCubit>().state.deckIndex == null
              ? 'Create'
              : 'Update',
        ),
        centerTitle: true,
        actions: [
          BlocConsumer<ManageDeckCubit, ManageDeckState>(
            listener: (context, state) {
              if (state.status == ManageDeckStatus.deckFailure) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
              if (state.status == ManageDeckStatus.deckSuccess) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              if (state.status == ManageDeckStatus.deckLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  if (context.read<ManageDeckCubit>().state.deckIndex == null) {
                    context.read<ManageDeckCubit>().createDeck();
                  } else {
                    context.read<ManageDeckCubit>().updateDeck();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deck name',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: TextEditingController(
                    text: context.read<ManageDeckCubit>().state.deck.name),
                decoration: const InputDecoration(
                  icon: Icon(Icons.folder),
                  border: OutlineInputBorder(),
                ),
                onChanged: (name) {
                  context.read<ManageDeckCubit>().onNameChanged(name);
                },
              ),
              const SizedBox(height: 20.0),
              Text(
                'Color',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 10.0),
              DeckColorPicker(
                manageDeckCubit: context.read<ManageDeckCubit>(),
              ),
              const SizedBox(height: 20.0),
              Text(
                'CSV document link',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 10.0),
              BlocConsumer<ManageDeckCubit, ManageDeckState>(
                listener: (context, state) {
                  if (state.status == ManageDeckStatus.csvFailure) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text(state.errorMessage)));
                  }
                },
                builder: (context, state) {
                  if (state.status == ManageDeckStatus.csvLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CsvLinkTextFieldDialog(
                    manageDeckCubit: context.read<ManageDeckCubit>(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
