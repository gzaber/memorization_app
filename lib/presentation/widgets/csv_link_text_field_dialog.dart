import 'package:flutter/material.dart';

import '../../state_management/state_management.dart';

class CsvLinkTextFieldDialog extends StatefulWidget {
  final ManageDeckCubit manageDeckCubit;

  const CsvLinkTextFieldDialog({
    Key? key,
    required this.manageDeckCubit,
  }) : super(key: key);

  @override
  State<CsvLinkTextFieldDialog> createState() => _CsvLinkTextFieldDialogState();
}

class _CsvLinkTextFieldDialogState extends State<CsvLinkTextFieldDialog> {
  @override
  Widget build(BuildContext context) {
    String _url = widget.manageDeckCubit.state.deck.url;

    return TextField(
      readOnly: true,
      controller:
          TextEditingController(text: widget.manageDeckCubit.state.deck.url),
      decoration: const InputDecoration(
        icon: Icon(Icons.link),
        border: OutlineInputBorder(),
      ),
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
        ),
      ),
    );
  }
}
