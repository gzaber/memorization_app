import 'package:flutter/material.dart';
import 'package:memorization_app/l10n/l10n.dart';

class CsvLinkDialog extends StatefulWidget {
  const CsvLinkDialog({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  static Future<String?> show(
    BuildContext context,
    String url,
  ) {
    return showDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (_) => CsvLinkDialog(url: url),
    );
  }

  @override
  State<CsvLinkDialog> createState() => _CsvLinkDialogState();
}

class _CsvLinkDialogState extends State<CsvLinkDialog> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String url = widget.url;

    return AlertDialog(
      title: Text(l10n.csvDocumentLink),
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
          child: Text(l10n.cancel),
        ),
        TextButton(
          key: const Key('csvLinkDialog_download_textButton'),
          onPressed: () => Navigator.pop(context, url),
          child: Text(l10n.download),
        ),
      ],
    );
  }
}
