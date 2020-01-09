import 'dart:async';

import 'package:race_timing_app/bloc/login/login_event.dart';
import 'package:race_timing_app/classes/validators.dart';
import 'package:race_timing_app/models/user.dart';
import 'package:race_timing_app/services/authentication_api.dart';

class LoginBloc with Validators {
  final AuthenticationApi authenticationApi;
  String _email;
  String _password;
  bool _emailValid;
  bool _passwordValid;

  final StreamController<String> _emailController = StreamController<String>.broadcast();
  Sink<String> get emailChanged => _emailController.sink;
  Stream<String> get email => _emailController.stream.transform(validateEmail);

  final StreamController<String> _passwordController = StreamController<String>.broadcast();
  Sink<String> get passwordChanged => _passwordController.sink;
  Stream<String> get password => _passwordController.stream.transform(validatePassword);

  final StreamController<bool> _enableLoginCreateButtonController = StreamController<bool>.broadcast();
  Sink<bool> get enableLoginCreateButtonChanged => _enableLoginCreateButtonController.sink;
  Stream<bool> get enableLoginCreateButton => _enableLoginCreateButtonController.stream;

  final StreamController<SwitchBetweenLoginAndSignUpBtnEvent> _switchLoginSignUpBtnController = StreamController<SwitchBetweenLoginAndSignUpBtnEvent>.broadcast();
  Sink<SwitchBetweenLoginAndSignUpBtnEvent> get switchLoginSignUpBtn => _switchLoginSignUpBtnController.sink;
  Stream<SwitchBetweenLoginAndSignUpBtnEvent> get loginOrSignUpBtn => _switchLoginSignUpBtnController.stream;

  final StreamController<LoginEvent> _loginOrCreateController = StreamController<LoginEvent>();
  Sink<LoginEvent> get loginOrCreateChanged => _loginOrCreateController.sink;
  Stream<LoginEvent> get loginOrCreate => _loginOrCreateController.stream;

  final StreamController<User> _loggedInUserController = StreamController<User>();
  Sink<User> get addLoggedInUser => _loggedInUserController.sink;
  Stream<User> get getLoggedInUser => _loggedInUserController.stream;

  LoginBloc(this.authenticationApi) {
    _startListenersIfEmailPasswordAreValid();
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _enableLoginCreateButtonController.close();
    _switchLoginSignUpBtnController.close();
    _loggedInUserController.close();
    _loginOrCreateController.close();
  }

  void _startListenersIfEmailPasswordAreValid() {
    email.listen((email) {
      _email = email;
      _emailValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _email = '';
      _emailValid = false;
      _updateEnableLoginCreateButtonStream();
    });
    password.listen((password) {
      _password = password;
      _passwordValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _password = '';
      _passwordValid = false;
      _updateEnableLoginCreateButtonStream();
    });
    loginOrCreate.listen((action) {
      action is LoginSelectedEvent ? _logIn() : _createAccount();
    });
  }

  void _updateEnableLoginCreateButtonStream() {
    if (_emailValid == true && _passwordValid == true) {
      enableLoginCreateButtonChanged.add(true);
    }
    else {
      enableLoginCreateButtonChanged.add(false);
    }
  }

  Future<String> _logIn() async {
    String _result = '';
    if(_emailValid && _passwordValid) {
      await authenticationApi.logIn(email: _email, password: _password).then((user) {
        print("success");
        _result = 'Success';
        addLoggedInUser.add(user);
      }).catchError((error) {
        print('Login error: ${error.message}');
        _result = error.message;
      });
      return _result;
    } else {
      return 'Email and Password are not valid';
    }
  }

  Future<String> _createAccount() async {
  }
}