import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class ManageDeckPage extends StatelessWidget {
  const ManageDeckPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ManageDeckView();
  }
}

class ManageDeckView extends StatelessWidget {
  const ManageDeckView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create / Update'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {},
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
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 22.0, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 10.0),
              const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.folder),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Color',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 22.0, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 10.0),
              const DeckColorPicker(),
              const SizedBox(height: 20.0),
              Text(
                'Link to document',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 22.0, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 10.0),
              const CsvLinkTextFieldDialog(),
            ],
          ),
        ),
      ),
    );
  }
}
