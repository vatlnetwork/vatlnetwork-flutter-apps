import 'package:flutter/material.dart';

import 'package:password_saver/controllers/server.dart';

class ConnectionFailure extends StatelessWidget {
  final Function setPage;

  const ConnectionFailure({super.key, required this.setPage});

  resetServer() async {
    final serverController = ServerController();
    await serverController.deleteCurrentServer();
    setPage();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Connection Error', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () { setPage(); },
              child: const Text('Retry')
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () { resetServer(); },
              child: const Text('Change Server')
            )
          ]
        )
      )
    );
  }
}