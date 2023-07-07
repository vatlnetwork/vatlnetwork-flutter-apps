import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:password_saver/api.dart';
import 'package:password_saver/controllers/account.dart';
import 'package:password_saver/domain/password.dart';
import 'package:password_saver/components/update_password.dart';

class PasswordSaver extends StatefulWidget {
  final Function setPage;

  const PasswordSaver({super.key, required this.setPage});

  @override
  State<PasswordSaver> createState() => _PasswordSaverState();
}

class _PasswordSaverState extends State<PasswordSaver> {
  final accountController = AccountController();
  final Api api = Api();

  late TextEditingController websiteState;
  late TextEditingController usernameState;
  late TextEditingController passwordState;

  final ThemeData redTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
    useMaterial3: true
  );

  List<Password> passwordsData = <Password>[];

  getPasswordData() async {
    passwordsData = [];
    final String token = await accountController.getCurrentToken();
    var passwordsDataResponse = await api.get('/saved_passwords/read', {"token": token});
    List passwordsDataList = jsonDecode(passwordsDataResponse);
    for (var i = 0; i < passwordsDataList.length; i++) {
      passwordsData.add(Password(
        id: passwordsDataList[i]["id"],
        website: passwordsDataList[i]["website"],
        username: passwordsDataList[i]["username"],
        password: passwordsDataList[i]["password"]
      ));
    }
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    websiteState = TextEditingController();
    usernameState = TextEditingController();
    passwordState = TextEditingController();
    getPasswordData();
  }

  @override
  dispose() {
    websiteState.dispose();
    usernameState.dispose();
    passwordState.dispose();
    super.dispose();
  }

  logOut() async {
    await accountController.deleteCurrentToken();
    widget.setPage();
  }

  openDialog(int id, String website, String username, String password) {
    showDialog(
      context: context,
      builder:(context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: UpdatePassword(
              id: id,
              website: website,
              username: username,
              password: password,
              onUpdate: getPasswordData
            )
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: passwordsData.length,
        itemBuilder: (context, index) {
          Password password = passwordsData[index];
          return GestureDetector(
            onTap: () { openDialog(password.id, password.website, password.username, password.password); },
            child: Card(            
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(passwordsData[index].website),
                    const SizedBox(height: 5),
                    Text(passwordsData[index].username)
                  ]
                )
              )
            ),
          );
        },
      )
    );
  }
}