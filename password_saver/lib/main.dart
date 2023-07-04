import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:password_saver/pages/server_setup.dart';
import 'package:password_saver/pages/login.dart';
import 'package:password_saver/pages/connection_failure.dart';
import 'package:password_saver/pages/password_saver.dart';

import 'package:password_saver/controllers/server.dart';
import 'package:password_saver/controllers/account.dart';
import 'package:password_saver/api.dart';

void main() {
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: OverlaySupport(
        child: MaterialApp(
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true
          ),
          themeMode: ThemeMode.system,
          darkTheme: ThemeData.from(
            colorScheme: const ColorScheme.dark(),
            useMaterial3: true
          ),
          debugShowCheckedModeBanner: false,
          home: const App()
        ),
      )
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final accountController = AccountController();
  final serverController = ServerController();
  final api = Api();

  Widget page = const Center(child: Text('Loading...'));

  getCurrentPage() async {
    String server = await serverController.getCurrentServer();
    if (server == 'none') {
      page = ServerSetup(setPage: getCurrentPage);
      setState(() {});
    } else {
      String isServerValid = await api.get('/api/check', {});
      if (isServerValid == 'yes') {
        String token = await accountController.getCurrentToken();
        if (token == 'none') {
          page = Login(setPage: getCurrentPage);
          setState(() {});
        } else {
          page = PasswordSaver(setPage: getCurrentPage);
          setState(() {});
        }
      } else {
        page = Center(
          child: ConnectionFailure(setPage: getCurrentPage)
        );
        setState(() {});
      }
    }
  }

  @override
  initState() {
    super.initState();
    getCurrentPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page
    );
  }
}