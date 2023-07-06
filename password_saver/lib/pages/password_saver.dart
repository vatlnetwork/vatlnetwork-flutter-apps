import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:password_saver/api.dart';
import 'package:password_saver/controllers/account.dart';
import 'package:password_saver/domain/password.dart';

class PasswordSaver extends StatefulWidget {
  final Function setPage;

  const PasswordSaver({super.key, required this.setPage});

  @override
  State<PasswordSaver> createState() => _PasswordSaverState();
}

class _PasswordSaverState extends State<PasswordSaver> {
  final accountController = AccountController();
  final Api api = Api();

  final ThemeData redTheme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
    useMaterial3: true
  );

  List<Password> passwordsData = <Password>[];

  getPasswordData() async {
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
    getPasswordData();
  }

  logOut() async {
    await accountController.deleteCurrentToken();
    widget.setPage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FixedColumnWidth(30)
        },
        children: [
          ...passwordsData.map((Password password) {
            return TableRow(
              children: [
                Text(password.website),
                Text(password.username),
                Text(password.password),
                Text(password.id.toString())
              ]
            );
          })
        ]
      )
    );
  }
}