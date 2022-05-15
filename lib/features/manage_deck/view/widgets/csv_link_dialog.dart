import 'package:flutter/material.dart';

import '../../manage_deck.dart';

class CsvLinkDialog extends StatefulWidget {
  final ManageDeckCubit manageDeckCubit;

  const CsvLinkDialog({
    Key? key,
    required this.manageDeckCubit,
  }) : super(key: key);

  @override
  State<CsvLinkDialog> createState() => _CsvLinkDialogState();
}

class _CsvLinkDialogState extends State<CsvLinkDialog> {
  @override
  Widget build(BuildContext context) {
    String _url = widget.manageDeckCubit.state.deck.url;

    return AlertDialog(
      title: const Text('Link to CSV document'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: TextEditingController(text: _url),
            onChanged: (csvUrl) {
              _url = csvUrl;
            },
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.manageDeckCubit.onUrlChanged(_url);
            widget.manageDeckCubit.readCsv();
            setState(() {
              Navigator.pop(context);
            });
          },
          child: const Text('Download'),
        ),
      ],
    );
  }
}
