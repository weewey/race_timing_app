import 'dart:async';

import 'package:race_timing_app/bloc/base_bloc.dart';
import 'package:race_timing_app/models/user.dart';
import 'package:race_timing_app/services/authentication_api.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc implements BaseBloc {
  final AuthenticationApi authenticationApi;

  AuthenticationBloc(this.authenticationApi) {
    onAuthChanged();
  }

  final BehaviorSubject<User> _authenticationStatusController =
      BehaviorSubject<User>();

  Sink<User> get addUser => _authenticationStatusController.sink;

  Stream<User> get user => _authenticationStatusController.stream;

  final StreamController<User> _logoutController = StreamController<User>();

  Sink<User> get logoutUser => _logoutController.sink;

  Stream<User> get listLogoutUser => _logoutController.stream;

  void dispose() {
    _authenticationStatusController.close();
    _logoutController.close();
  }

  void onAuthChanged() {
    listLogoutUser.listen((user) async {
      await authenticationApi.logOut(user).then((success) {
        if(success) {
          print("log out successful");
          addUser.add(null);
        }
      }).catchError((error) {
        print("log out unsuccessful");
        print(error.message);
      });
    });
  }

  User getCurrentUser() {
    return (_authenticationStatusController.value is User)
        ? _authenticationStatusController.value
        : null;
  }
}
