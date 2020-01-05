import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:race_timing_app/models/login_request.dart';
import 'package:race_timing_app/models/user.dart';
import 'package:race_timing_app/services/authentication_api.dart';

class AuthenticationService implements AuthenticationApi {
  static final AuthenticationService _authService =
      AuthenticationService._internal(http.Client());
  http.Client client;

  factory AuthenticationService() {
    return _authService;
  }

  AuthenticationService._internal(this.client);

  static const String host = "https://baa86b9e.ngrok.io";
  final String loginUrl = '$host/api/login';

  final StreamController<User> _authStateController = StreamController<User>();

  Sink<User> get updateAuthState => _authStateController.sink;

  Stream<User> get onAuthStateChanged => _authStateController.stream;

  @override
  Future<User> authenticate({String email, String password}) async {
    http.Response res = await client.post(loginUrl,
        headers: {"Content-Type": "application/json"},
        body: LoginRequest(email, password).toJson());

    if (res.statusCode == 200) {
      String token = res.headers["authorization"];
      var response = jsonDecode(res.body);
      User user =
          User(token: token, id: response["id"], email: response["email"]);
      updateAuthState.add(user);
      return user;
    } else {
      throw Exception("Please check the login details provided.");
    }
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    return null;
  }

  void close() {
    client.close();
    _authStateController.close();
  }
}
