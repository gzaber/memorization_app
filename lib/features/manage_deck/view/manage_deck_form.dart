import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manage_deck.dart';

class ManageDeckForm extends StatelessWidget {
  const ManageDeckForm({Key? key}) : super(key: key);

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
        actions: const [
          _SaveDeckIcon(),
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
              const _DeckNameInput(),
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
              const _CsvLinkInput(),
            ],
          ),
        ),
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
    );
  }
}

class _DeckNameInput extends StatelessWidget {
  const _DeckNameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(
          text: context.read<ManageDeckCubit>().state.deck.name),
      decoration: const InputDecoration(
        icon: Icon(Icons.folder),
        border: OutlineInputBorder(),
      ),
      onChanged: (name) {
        context.read<ManageDeckCubit>().onNameChanged(name);
      },
    );
  }
}

class _CsvLinkInput extends StatelessWidget {
  const _CsvLinkInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageDeckCubit, ManageDeckState>(
      listener: (context, state) {
        if (state.status == ManageDeckStatus.csvFailure) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        if (state.status == ManageDeckStatus.csvLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return TextField(
          readOnly: true,
          controller: TextEditingController(
              text: context.read<ManageDeckCubit>().state.deck.url),
          decoration: const InputDecoration(
            icon: Icon(Icons.link),
            border: OutlineInputBorder(),
          ),
          onTap: () => showDialog(
            context: context,
            builder: (_) =>
                CsvLinkDialog(manageDeckCubit: context.read<ManageDeckCubit>()),
          ),
        );
      },
    );
  }
}
