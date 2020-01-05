import 'dart:async';

import 'package:race_timing_app/models/user.dart';

abstract class AuthenticationApi {

  Stream<User> get onAuthStateChanged;

  Future<User> authenticate({String email, String password});

  Future<void> logOut();

  void close();
}