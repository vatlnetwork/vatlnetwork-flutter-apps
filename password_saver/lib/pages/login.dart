import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:password_saver/api.dart';
import 'package:password_saver/controllers/notifications.dart';
import 'package:password_saver/controllers/account.dart';
import 'package:password_saver/controllers/server.dart';

class Login extends StatefulWidget {
  final Function setPage;

  const Login({super.key, required this.setPage});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailState;
  late TextEditingController _passwordState;

  final api = Api();
  final notification = NotificationsController();
  final accountController = AccountController();
  final serverController = ServerController();

  @override
  initState() {
    super.initState();
    _emailState = TextEditingController();
    _passwordState = TextEditingController();
  }

  @override
  dispose() {
    _emailState.dispose();
    _passwordState.dispose();
    super.dispose();
  }

  login() async {
    if (_emailState.text.isEmpty) {
      notification.warning('No Email!');
      return;
    }
    if (_passwordState.text.isEmpty) {
      notification.warning('No Password!');
      return;
    }
    String response = await api.post('/api/submit_login', {
      "email": _emailState.text,
      "password": _passwordState.text
    });
    if (response == 'success') {
      await accountController.setCurrentToken(_emailState.text, _passwordState.text);
      widget.setPage();
    } else {
      notification.error(response);
    }
  }

  signup() async {
    String currentServer = await serverController.getCurrentServer();
    final Uri url = Uri.http(currentServer, '/');
    if (!await launchUrl(url)) {
      notification.error('There was an error launching the signup URL.');
    }
  }

  resetServer() async {
    await serverController.deleteCurrentServer();
    widget.setPage();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email'
              ),
              autofocus: true,
              onSubmitted: (value) { login(); },
              controller: _emailState
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password'
              ),
              onSubmitted: (value) { login(); },
              controller: _passwordState,
              obscureText: true
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { login(); },
                child: const Text('Log In')
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { signup(); },
                child: const Text('Sign Up')
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { resetServer(); },
                child: const Text('Change Server')
              )
            )
          ]
        )
      )
    );
  } 
}