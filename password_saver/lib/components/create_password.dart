import 'package:flutter/material.dart';

import 'package:password_saver/controllers/notifications.dart';
import 'package:password_saver/controllers/passwords.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final PasswordsController passwordsController = PasswordsController();
  final NotificationsController notification = NotificationsController();

  late TextEditingController websiteState;
  late TextEditingController usernameState;
  late TextEditingController passwordState;

  bool showPassword = false;

  @override
  initState() {
    super.initState();
    websiteState = TextEditingController();
    usernameState = TextEditingController();
    passwordState = TextEditingController();
  }

  @override
  dispose() {
    websiteState.dispose();
    usernameState.dispose();
    passwordState.dispose();
    super.dispose();
  }

  checkPassword(String website, String username, String password) async {
    String status = await passwordsController.createPassword(website, username, password);
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

  toggleShowPassword() {
    showPassword = !showPassword;
    setState(() {});
  }

  @override
  Widget build(BuildContext contexn) {
    return Column(
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
          obscureText: !showPassword,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Password',
            prefixIcon: const Icon(Icons.password),
            suffixIcon: IconButton(
              onPressed: () { toggleShowPassword(); },
              icon: showPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)
            )
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
    );
  }
}