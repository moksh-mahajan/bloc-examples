import 'package:bloc_examples/auth/auth_errors.dart';
import 'package:bloc_examples/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<void> showAuthError({
  required BuildContext context,
  required AuthError error,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: error.dialogTitle,
    content: error.dialogText,
    optionsBuilder: () => {
      'OK': true,
    },
  );
}
