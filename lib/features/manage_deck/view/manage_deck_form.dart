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
                color: context.read<ManageDeckCubit>().state.deck.color,
                onColorChanged: (color) {
                  context.read<ManageDeckCubit>().onColorChanged(color);
                },
              ),
              const SizedBox(height: 20.0),
              Text(
                'CSV document link',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 10.0),
              const _CsvLinkInput(),
              const SizedBox(height: 10.0),
              const _EntriesNumber(),
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
        if (state.status == ManageDeckStatus.failure) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
        if (state.status == ManageDeckStatus.success) {
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

class _DeckNameInput extends StatelessWidget {
  const _DeckNameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('manageDeckPage_name_textField'),
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
          key: const Key('manageDeckPage_url_textField'),
          readOnly: true,
          controller: TextEditingController(
              text: context.read<ManageDeckCubit>().state.deck.url),
          decoration: const InputDecoration(
            icon: Icon(Icons.link),
            border: OutlineInputBorder(),
          ),
          onTap: () => showDialog(
            context: context,
            builder: (_) => CsvLinkDialog(
                url: context.read<ManageDeckCubit>().state.deck.url),
          ).then((value) async {
            if (value != null) {
              context.read<ManageDeckCubit>().onUrlChanged(value);
              await context.read<ManageDeckCubit>().readCsv();
            }
          }),
        );
      },
    );
  }
}

class _EntriesNumber extends StatelessWidget {
  const _EntriesNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageDeckCubit, ManageDeckState>(
      builder: (context, state) {
        final entriesNumber =
            context.read<ManageDeckCubit>().state.deck.entries.length;
        return TextField(
          enabled: false,
          controller: TextEditingController(
              text: entriesNumber == 1 ? '1 entry' : '$entriesNumber entries'),
          decoration: const InputDecoration(
            icon: Icon(Icons.list),
            border: InputBorder.none,
          ),
        );
      },
    );
  }
}
