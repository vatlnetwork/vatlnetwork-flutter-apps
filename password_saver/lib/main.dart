import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:password_saver/controllers/notifications.dart';
import 'package:password_saver/controllers/passwords.dart';
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
  final AccountController accountController = AccountController();
  final ServerController serverController = ServerController();
  final Api api = Api();
  final PasswordsController passwordsController = PasswordsController();
  final NotificationsController notification = NotificationsController();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final Widget loadingPage = const Center(child: Text('Loading...'));

  Widget page = const Center(child: Text('Loading...'));
  String currentPage = '';

  getCurrentPage() async {
    String server = await serverController.getCurrentServer();
    if (server == 'none') {
      page = ServerSetup(setPage: getCurrentPage);
      currentPage = 'server_setup';
      setState(() {});
    } else {
      String isServerValid = await api.get('/api/check', {});
      if (isServerValid == 'yes') {
        String token = await accountController.getCurrentToken();
        if (token == 'none') {
          page = Login(setPage: getCurrentPage);
          currentPage = 'login';
          setState(() {});
        } else {
          String response = await api.get('/user_info/email', {"token": token});
          if (response == 'invalid_token') {
            await accountController.deleteCurrentToken();
            getCurrentPage();
          } else {
            page = PasswordSaver(setPage: getCurrentPage);
            currentPage = 'password_saver';
            setState(() {});
          }
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
    page = loadingPage;
    getCurrentPage();
  }

  logOut() {
    accountController.deleteCurrentToken();
    _key.currentState!.closeDrawer();
    getCurrentPage();
  }

  onCreate() {
    currentPage = 'loading_create';
    page = loadingPage;
    setState(() {});
  }

  createPassword(BuildContext context) {
    passwordsController.openCreateDialog(context, onCreate);
  }

  destroyAllPasswords() async {
    String response = await passwordsController.destroyAllPasswords();
    if (response == 'success') {
      currentPage = 'loading_create';
      page = loadingPage;
      notification.success('Completed');
      _key.currentState!.closeDrawer();
      setState(() {});
    } else {
      notification.error(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentPage == 'loading_create') {
      getCurrentPage();
    }

    return Scaffold(
      key: _key,
      appBar: AppBar(
        actions: [
          currentPage == 'password_saver' ? IconButton(
            onPressed: () { createPassword(context); },
            tooltip: 'New Password',
            icon: const Icon(Icons.add, color: Colors.green)
          ) : const SizedBox()
        ]
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              currentPage == 'password_saver' ? ListTile(
                title: const Text('Delete All', style: TextStyle(color: Colors.red)),
                onTap: () { destroyAllPasswords(); }
              ) : const SizedBox(),
              currentPage == 'password_saver' ? ListTile(
                title: const Text('Log Out', style: TextStyle(color: Colors.red)),
                onTap: () { logOut(); }
              ) : const SizedBox()
            ]
          )
        )
      ),
      body: page
    );
  }
}