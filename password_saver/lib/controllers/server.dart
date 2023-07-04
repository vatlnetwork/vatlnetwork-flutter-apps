import 'package:shared_preferences/shared_preferences.dart';

class ServerController {
  getCurrentServer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? currentServer = prefs.getString('current_server');
    return currentServer ?? 'none';
  }

  setCurrentServer(serverAddress) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_server', serverAddress);
  }

  deleteCurrentServer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_server');
  }
}