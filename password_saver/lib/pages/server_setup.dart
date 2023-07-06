import 'package:flutter/material.dart';

import 'package:password_saver/controllers/notifications.dart';
import 'package:password_saver/controllers/server.dart';
import 'package:password_saver/api.dart';

class ServerSetup extends StatefulWidget {
  final Function setPage;
  const ServerSetup({super.key, required this.setPage});

  @override
  State<ServerSetup> createState() => _ServerSetupState();
}

class _ServerSetupState extends State<ServerSetup> {
  final notification = NotificationsController();
  final api = Api();
  final serverController = ServerController();
  
  late TextEditingController _serverAddressState;

  @override
  initState() {
    super.initState();
    _serverAddressState = TextEditingController();
  }

  @override
  void dispose() {
    _serverAddressState.dispose();
    super.dispose();
  }

  checkServerAddress(String address) async {
    if (address.isEmpty) {
      notification.warning('Blank Address!');
      return;
    }
    await serverController.setCurrentServer(address);
    var addressIsValid = await api.get('/api/check', {});
    if (addressIsValid == 'yes') {
      notification.success('Connected!');
      widget.setPage();
    } else {
      await serverController.deleteCurrentServer();
      notification.error('Could not connect to server!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Connect to a VATLNetwork Cloud Server', 
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextField(
              onSubmitted: (value) {
                checkServerAddress(value);
              },
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Server Address (ex: vatlnetwork.ddns.net)'
              ),
              controller: _serverAddressState
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { checkServerAddress(_serverAddressState.text); },
                child: const Text('Connect')
              ),
            )
          ],
        ),
      )
    );
  }
}