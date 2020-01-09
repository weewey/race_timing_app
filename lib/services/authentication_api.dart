import 'dart:async';

import 'package:race_timing_app/models/user.dart';

abstract class AuthenticationApi {

  Future<User> logIn({String email, String password});

  Future<bool> logOut(User user);

  Future<bool> signUp(String token);

}