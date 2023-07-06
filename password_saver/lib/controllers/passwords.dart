import 'package:flutter/material.dart';

import 'package:password_saver/api.dart';
import 'package:password_saver/controllers/account.dart';
import 'package:password_saver/components/create_password.dart';

class PasswordsController {
  createPassword(String website, String username, String password) async {
    final Api api = Api();
    final AccountController accountController = AccountController();
    final String token = await accountController.getCurrentToken();

    if (website.isEmpty || username.isEmpty || password.isEmpty) {
      return 'missing_data';
    } else {
      String response = await api.post('/saved_passwords/create', {
        "token": token,
        "website": website,
        "username": username,
        "password": password
      });
      return response;
    }
  }

  openCreateDialog(BuildContext context, Function onCreate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: 350,
              child: CreatePassword(onCreate: onCreate)
            )
          )
        );
      }
    );
  }
}