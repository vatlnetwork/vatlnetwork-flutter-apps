import 'package:flutter/material.dart';

import 'package:password_saver/controllers/account.dart';

class PasswordSaver extends StatefulWidget {
  final Function setPage;

  const PasswordSaver({super.key, required this.setPage});

  @override
  State<PasswordSaver> createState() => _PasswordSaverState();
}

class _PasswordSaverState extends State<PasswordSaver> {
  final accountController = AccountController();

  final ThemeData redTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
    useMaterial3: true
  );

  logOut() async {
    await accountController.deleteCurrentToken();
    widget.setPage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              ElevatedButton(
                onPressed: () { logOut(); },
                child: const Text('Log Out', style: TextStyle(color: Colors.red))
              )
            ]
          )
        ]
      ),
    );
  }
}