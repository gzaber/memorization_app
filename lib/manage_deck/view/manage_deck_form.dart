import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memorization_app/l10n/l10n.dart';
import 'package:memorization_app/manage_deck/manage_deck.dart';

class ManageDeckForm extends StatelessWidget {
  const ManageDeckForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.deckName, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          const _DeckNameInput(),
          const SizedBox(height: 20),
          Text(
            l10n.color,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          DeckColorPicker(
            color: context.read<ManageDeckCubit>().state.deck.color,
            onColorChanged: (color) {
              context.read<ManageDeckCubit>().onColorChanged(color);
            },
          ),
          const SizedBox(height: 20),
          Text(
            l10n.csvDocumentLink,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          const _CsvLinkInput(),
          const SizedBox(height: 10),
          const _EntriesNumber(),
        ],
      ),
    );
  }
}

class _DeckNameInput extends StatelessWidget {
  const _DeckNameInput({Key? key}) : super(key: key);

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
  const _CsvLinkInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<ManageDeckCubit, ManageDeckState>(
      listener: (context, state) {
        if (state.status == ManageDeckStatus.csvFailure) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.csvFailure)));
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
          onTap: () => CsvLinkDialog.show(
            context,
            context.read<ManageDeckCubit>().state.deck.url,
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
    final l10n = context.l10n;
    final entriesNumber = context
        .select((ManageDeckCubit cubit) => cubit.state.deck.entries.length);
    return TextField(
      key: const Key('manageDeckPage_entriesNumber_textField'),
      enabled: false,
      controller:
          TextEditingController(text: l10n.entriesNumber(entriesNumber)),
      decoration: const InputDecoration(
        icon: Icon(Icons.list),
        border: InputBorder.none,
      ),
    );
  }
}
