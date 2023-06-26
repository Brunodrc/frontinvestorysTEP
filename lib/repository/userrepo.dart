import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db.dart';
import '../models/user.dart';

class UserRepository {
  // create e login
  Future<bool> createLogin(
      String name, String email, String password, String riskprofile) async {
    final db = DatabaseConnect();
    var url = Uri.parse('http://10.0.2.2:8000/auth/signup/');
    var res = await http.post(url, body: {
      'name': name,
      'email': email,
      'password': password,
      'risk_profile': riskprofile.toUpperCase()
    });
    if (res.statusCode == 200) {
      var acesstoken = jsonDecode(res.body)['access_token'];
      var refreshtoken = jsonDecode(res.body)['refresh_token'];
      var user_data = jsonDecode(res.body)['user'];
      var investor_data = jsonDecode(res.body)['investor'];

      print(jsonDecode(res.body));
      print("Response user -->${user_data}");
      print("Response user id-->${user_data['id']}");
      print("Response investor-->${investor_data}");
      print("Response token-->${acesstoken}");

      final User user = User(
        id: user_data['id'].toString(),
        name: user_data['name'],
        email: user_data['email'],
        riskProfile: investor_data['risk_profile'],
        acessToken: acesstoken,
        refreshToken: refreshtoken,
      );
      final userlist = await db.getUsers();
      if (userlist.isNotEmpty) {
        await db.deleteToken(userlist[0].id);
        await db.insertUser(user);
      } else {
        await db.insertUser(user);
      }
      return true;
    } else {
      try {
        print((res.body));
      } catch (e) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> login(
    String email,
    String password,
  ) async {
    final db = DatabaseConnect();
    var url = Uri.parse('http://10.0.2.2:8000/auth/login/');
    Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };

    Response res = await http.post(
      url,
      body: body,
    );
    print('Res enviado: ${res.body}');
    if (res.statusCode == 200) {
      final userlist = await db.getUsers();
      var token = jsonDecode(res.body)['access'];
      if (userlist.isNotEmpty) {
        await db.deleteToken(userlist[0].id);
        await db.updateToken(newToken: token, userId: userlist[0].id);
        print('deu tudo certo!!!!');
        return true;
      } else {
        String emailFull = email;
        List<String> parts = emailFull.split('@');
        String obtainName = parts.first;
        var acctoken = jsonDecode(res.body)['access'];
        var refrtoken = jsonDecode(res.body)['refresh'];

        User user = User(
          id: "1",
          name: obtainName,
          email: email,
          riskProfile: 'C',
          acessToken: acctoken,
          refreshToken: refrtoken,
        );
        await db.insertUser(user);
        return true;
      }
    } else {
      try {
        print((res.body));
      } catch (e) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> logout() async {
    final db = DatabaseConnect();
    final userlist = await db.getUsers();
    await db.deleteToken(userlist[0].id);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.clear();
    return true;
  }
}
