import 'package:bloc_examples/bloc/app_bloc.dart';
import 'package:bloc_examples/bloc/app_event.dart';
import 'package:bloc_examples/dialogs/delete_account_dialog.dart';
import 'package:bloc_examples/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuAction { logout, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      itemBuilder: (context) {
        return const [
          PopupMenuItem(
            value: MenuAction.logout,
            child: Text('Logout'),
          ),
          PopupMenuItem(
            value: MenuAction.deleteAccount,
            child: Text('Delete Account'),
          ),
        ];
      },
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogout = await showLogoutDialog(context);
            if (shouldLogout) {
              context.read<AppBloc>().add(const AppEventLogout());
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount = await showDeleteAccountDialog(context);
            if (shouldDeleteAccount) {
              context.read<AppBloc>().add(const AppEventDeleteAccount());
            }
            break;
        }
      },
    );
  }
}
