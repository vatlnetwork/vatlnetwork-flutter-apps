import 'package:flutter/material.dart';

class UpdatePassword extends StatefulWidget {
  final int id;
  final String website;
  final String username;
  final String password;

  const UpdatePassword({
    super.key,
    required this.id,
    required this.website,
    required this.username,
    required this.password
  });

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  late TextEditingController websiteState;
  late TextEditingController usernameState;
  late TextEditingController passwordState;

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

  updatePassword(int id) {
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
            autofocus: true
          ),
          const SizedBox(height: 10),
          TextField(
            controller: usernameState,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
              prefixIcon: Icon(Icons.face)
            )
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
            obscureText: !showPassword,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () { updatePassword(widget.id); },
              child: const Text('Update')
            )
          )
        ]
      ),
    );
  }
}