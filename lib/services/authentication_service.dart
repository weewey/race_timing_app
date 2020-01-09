import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:race_timing_app/models/login_request.dart';
import 'package:race_timing_app/models/user.dart';
import 'package:race_timing_app/services/authentication_api.dart';

class AuthenticationService implements AuthenticationApi {
  http.Client client = http.Client();

  static const String host = 'https://3ad524cc.ngrok.io/api';
  final String loginUrl = '$host/login';
  final String logOutUrl = '$host/logout';
  final Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  };

  @override
  Future<User> logIn({String email, String password}) async {
    http.Response res = await client.post(loginUrl,
        headers: {"Content-Type": "application/json"},
        body: LoginRequest(email, password).toJson());

    if (res.statusCode == 200) {
      String token = res.headers["authorization"];
      var response = jsonDecode(res.body);
      User user = User(token: token, id: response["id"], email: response["email"]);
      return user;
    } else {
      throw Exception("Please check the login details provided.");
    }
  }

  @override
  Future<bool> logOut(User user) async {
    http.Response res = await client.delete(logOutUrl, headers: {'Authorization': '${user.token}'});
    if (res.statusCode == 204) {
      return true;
    } else {
      throw Exception("failed to logout");
    }
  }

  @override
  Future<bool> signUp(String token) {
    // TODO: implement signUp
    return null;
  }

}
