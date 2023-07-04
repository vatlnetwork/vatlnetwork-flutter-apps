import 'package:shared_preferences/shared_preferences.dart';

import 'package:password_saver/api.dart';

class AccountController {
  getCurrentToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null) {
      return 'none';
    } else {
      return token;
    }
  }

  setCurrentToken(String email, String password) async {
    final api = Api();
    var data = await api.post('/api/submit_login', {
      "email": email, 
      "password": password,
      "get_token": "yes"
    });
    print(data);
  }
}