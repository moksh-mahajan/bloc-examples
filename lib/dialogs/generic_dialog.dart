import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog<T?>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys
            .map(
              (optionTitle) => TextButton(
                onPressed: () {
                  final value = options[optionTitle];
                  if (value != null) {
                    Navigator.pop(context, value);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Text(optionTitle),
              ),
            )
            .toList(),
      );
    },
  );
}
