import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/repositories.dart';
import '../manage_deck.dart';

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
      child: const ManageDeckForm(),
    );
  }
}
