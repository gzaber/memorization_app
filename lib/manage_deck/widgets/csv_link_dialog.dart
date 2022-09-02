import 'package:flutter/material.dart';

class CsvLinkDialog extends StatefulWidget {
  final String url;

  const CsvLinkDialog({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<CsvLinkDialog> createState() => _CsvLinkDialogState();
}

class _CsvLinkDialogState extends State<CsvLinkDialog> {
  @override
  Widget build(BuildContext context) {
    String url = widget.url;

    return AlertDialog(
      title: const Text('Link to CSV document'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: const Key('csvLinkDialog_url_textField'),
            controller: TextEditingController(text: url),
            onChanged: (csvUrl) {
              url = csvUrl;
            },
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        TextButton(
          key: const Key('csvLinkDialog_cancel_textButton'),
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        TextButton(
          key: const Key('csvLinkDialog_download_textButton'),
          onPressed: () => Navigator.pop(context, url),
          child: const Text('Download'),
        ),
      ],
    );
  }
}
