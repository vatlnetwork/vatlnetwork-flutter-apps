import 'package:flutter/material.dart';

import 'package:password_saver/api.dart';
import 'package:password_saver/controllers/account.dart';
import 'package:password_saver/controllers/notifications.dart';

class UpdatePassword extends StatefulWidget {
  final int id;
  final String website;
  final String username;
  final String password;
  final Function onUpdate;

  const UpdatePassword({
    super.key,
    required this.id,
    required this.website,
    required this.username,
    required this.password,
    required this.onUpdate
  });

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  late TextEditingController websiteState;
  late TextEditingController usernameState;
  late TextEditingController passwordState;

  final Api api = Api();

  final AccountController accountController = AccountController();
  final NotificationsController notification = NotificationsController();

  @override
  initState() {
    super.initState();
    websiteState = TextEditingController();
    usernameState = TextEditingController();
    passwordState = TextEditingController();
    websiteState.text = widget.website;
    usernameState.text = widget.username;
    passwordState.text = widget.password;
  }

  @override
  dispose() {
    websiteState.dispose();
    usernameState.dispose();
    passwordState.dispose();
    super.dispose();
  }

  bool showPassword = false;

  toggleShowPassword() {
    showPassword = !showPassword;
    setState(() {});
  }

  updatePassword(int id) async {
    String website = websiteState.text;
    String username = usernameState.text;
    String password = passwordState.text;

    if (website.isEmpty || username.isEmpty || password.isEmpty) {
      notification.warning('All fields are required.');
      return;
    }

    String token = await accountController.getCurrentToken();
    String response = await api.post('/saved_passwords/update', {
      "token": token,
      "id": id.toString(),
      "website": website,
      "username": username,
      "password": password
    });

    if (response == 'success') {
      widget.onUpdate();
      notification.success('Updated');
    } else {
      notification.error(response);
    }
  }

  deletePassword(int id) async {
    String token = await accountController.getCurrentToken();
    String response = await api.post('/saved_passwords/destroy', {
      "token": token,
      "id": id.toString()
    });

    if (response == 'success') {
      widget.onUpdate();
      notification.success('Deleted');
    } else {
      notification.error(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Website',
              prefixIcon: Icon(Icons.web)
            ),
            controller: websiteState,
            autofocus: true,
            onSubmitted: (value) { updatePassword(widget.id); Navigator.pop(context); },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: usernameState,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
              prefixIcon: Icon(Icons.face)
            ),
            onSubmitted: (value) { updatePassword(widget.id); Navigator.pop(context); },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: passwordState,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Password',
              prefixIcon: const Icon(Icons.password),
              suffixIcon: IconButton(
                onPressed: () { toggleShowPassword(); },
                icon: showPassword ? const Icon(Icons.visibility_outlined) : const Icon(Icons.visibility_off_outlined)
              )
            ),
            onSubmitted: (value) { updatePassword(widget.id); Navigator.pop(context); },
            obscureText: !showPassword,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () { updatePassword(widget.id); Navigator.pop(context); },
              child: const Text('Update')
            )
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () { deletePassword(widget.id); Navigator.pop(context); },
              child: const Text('Delete', style: TextStyle(color: Colors.red))
            )
          )
        ]
      ),
    );
  }
}