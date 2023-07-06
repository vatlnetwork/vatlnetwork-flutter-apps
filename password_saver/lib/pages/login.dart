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

  String currentServer = '';
  bool showPassword = false;

  toggleShowPassword() {
    showPassword = !showPassword;
    setState(() {});
  }

  getCurrentServer() async {
    currentServer = await serverController.getCurrentServer();
    setState(() {});
  }

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
      notification.success('Loggin In!');
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
    if (currentServer == '') {
      getCurrentServer();
    }

    return Center(
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Log in to $currentServer'),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined)
              ),
              autofocus: true,
              onSubmitted: (value) { login(); },
              controller: _emailState
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Password',
                prefixIcon: const Icon(Icons.password),
                suffixIcon: IconButton(
                  onPressed: () { toggleShowPassword(); },
                  icon: showPassword ? const Icon(Icons.visibility_outlined) : const Icon(Icons.visibility_off_outlined)
                )
              ),
              onSubmitted: (value) { login(); },
              controller: _passwordState,
              obscureText: !showPassword
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