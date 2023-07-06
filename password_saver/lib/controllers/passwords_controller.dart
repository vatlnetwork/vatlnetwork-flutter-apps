import 'package:flutter/material.dart';
import 'package:password_saver/api.dart';
import 'package:password_saver/controllers/account.dart';

import 'package:password_saver/controllers/notifications.dart';

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

  openCreateDialog(context) {
    final TextEditingController websiteState = TextEditingController();
    final TextEditingController usernameState = TextEditingController();
    final TextEditingController passwordState = TextEditingController();
    final NotificationsController notification = NotificationsController();

    checkPassword(String website, String username, String password) async {
      String status = await createPassword(website, username, password);
      if (status == 'missing_data') {
        notification.warning('All fields are required.');
      } else if (status == 'success') {
        notification.success('Created');
        websiteState.text = '';
        usernameState.text = '';
        passwordState.text = '';
      } else {
        notification.error(status);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: 350,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: websiteState,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Website',
                      prefixIcon: Icon(Icons.web)
                    ),
                    autofocus: true,
                    onSubmitted: (value) { checkPassword(websiteState.text, usernameState.text, passwordState.text); }
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: usernameState,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.face)
                    ),
                    onSubmitted: (value) { checkPassword(websiteState.text, usernameState.text, passwordState.text); }
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordState,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.password)
                    ),
                    onSubmitted: (value) { checkPassword(websiteState.text, usernameState.text, passwordState.text); },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () { checkPassword(websiteState.text, usernameState.text, passwordState.text); },
                      child: const Text('Create')
                    ),
                  )
                ]
              ),
            )
          )
        );
      }
    );
  }
}