import 'package:http/http.dart' as http;

import 'package:password_saver/controllers/server.dart';

class Api {
  get(path, Map<String, dynamic>params) async {
    final serverController = ServerController();
    final String server = await serverController.getCurrentServer();
    if (server == 'none') {
      throw ArgumentError('No Current Server!');
    } else {
      var url = Uri.http(server, path, params);
      try {
        var response = await http.get(url);
        if (response.statusCode == 200) {
          return response.body;
        } else {
          return 'request_error';
        }
      }
      catch(e) {
        return 'request_error';
      }
    }
  }

  post(path, params) async {
    final serverController = ServerController();
    final String server = await serverController.getCurrentServer();
    if (server == 'none') {
      throw ArgumentError('No Current Server!');
    } else {
      var url = Uri.http(server, path);
      try {
        var response = await http.post(url, body: params);
        return response.body;
      }
      catch(e) {
        return e.toString();
      }
    }
  }
}