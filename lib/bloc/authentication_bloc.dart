import 'dart:async';

import 'package:race_timing_app/bloc/base_bloc.dart';
import 'package:race_timing_app/models/user.dart';
import 'package:race_timing_app/services/authentication_api.dart';

class AuthenticationBloc implements BaseBloc {
  final AuthenticationApi authenticationApi;

  AuthenticationBloc(this.authenticationApi){
    onAuthChanged();
  }

  final StreamController<User> _authenticationStatusController = StreamController<User>();
  Sink<User> get addUser => _authenticationStatusController.sink;
  Stream<User> get user => _authenticationStatusController.stream;

  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  void dispose(){
    _authenticationStatusController.close();
    _logoutController.close();
    authenticationApi.close();
  }

  void _signOut() {
    authenticationApi.logOut();
  }

  void onAuthChanged(){
    authenticationApi.onAuthStateChanged.listen((user) {
      if(user is User){
        addUser.add(user);
      } else {
        addUser.add(null);
      }
    });
    _logoutController.stream.listen((logout){
      if(logout == true) {
        _signOut();
      }
    });

  }
}