import 'dart:async';

import 'package:race_timing_app/bloc/login/login_event.dart';
import 'package:race_timing_app/classes/validators.dart';
import 'package:race_timing_app/models/user.dart';
import 'package:race_timing_app/services/authentication_api.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final AuthenticationApi authenticationApi;
  String _email;
  String _password;
  bool _emailValid = false;
  bool _passwordValid = false;
  bool _passwordConfirmationValid = false;

  final StreamController<String> _emailController =
      StreamController<String>.broadcast();

  Sink<String> get emailChanged => _emailController.sink;

  Stream<String> get email => _emailController.stream.transform(validateEmail);

  final StreamController<String> _passwordController =
      StreamController<String>.broadcast();

  Sink<String> get passwordChanged => _passwordController.sink;

  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  final StreamController<String> _passwordConfirmationController =
      StreamController<String>.broadcast();

  EventSink<String> get passwordConfirmationChanged =>
      _passwordConfirmationController.sink;

  Stream<bool> get passwordConfirmationValid =>
      Rx.combineLatest2(password, _passwordConfirmationController.stream,
          (password, passwordConfirmation) {
        if (password == passwordConfirmation) {
          _passwordConfirmationValid = true;
        } else {
          _passwordConfirmationValid = false;
        }
        return _passwordConfirmationValid;
      }).transform(validatePasswordConfirmation);

  final StreamController<bool> _enableLoginCreateButtonController =
      StreamController<bool>.broadcast();

  Sink<bool> get enableLoginCreateButtonChanged =>
      _enableLoginCreateButtonController.sink;

  Stream<bool> get enableLoginCreateButton =>
      _enableLoginCreateButtonController.stream;

  final BehaviorSubject<DisplayLoginOrSignUpFormEvent>
      _switchLoginSignUpBtnController =
      BehaviorSubject<DisplayLoginOrSignUpFormEvent>.seeded(
          DisplayLoginFormEvent());

  Sink<DisplayLoginOrSignUpFormEvent> get switchLoginSignUpBtn =>
      _switchLoginSignUpBtnController.sink;

  Stream<DisplayLoginOrSignUpFormEvent> get loginOrSignUpBtn =>
      _switchLoginSignUpBtnController.stream;

  final StreamController<LoginEvent> _loginOrCreateController =
      StreamController<LoginEvent>();

  Sink<LoginEvent> get loginOrCreateChanged => _loginOrCreateController.sink;

  Stream<LoginEvent> get loginOrCreate => _loginOrCreateController.stream;

  final StreamController<User> _loggedInUserController =
      StreamController<User>();

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
    _passwordConfirmationController.close();
  }

  void _startListenersIfEmailPasswordAreValid() {
    email.listen((email) {
      _email = email;
      _emailValid = true;
      _updateEnableLoginCreateButtonStream(
          _switchLoginSignUpBtnController.value,
          _emailValid,
          _passwordValid,
          _passwordConfirmationValid);
    }).onError((error) {
      _email = '';
      _emailValid = false;
      _updateEnableLoginCreateButtonStream(
          _switchLoginSignUpBtnController.value,
          _emailValid,
          _passwordValid,
          _passwordConfirmationValid);
    });
    password.listen((password) {
      _password = password;
      _passwordValid = true;
      _updateEnableLoginCreateButtonStream(
          _switchLoginSignUpBtnController.value,
          _emailValid,
          _passwordValid,
          _passwordConfirmationValid);
    }).onError((error) {
      _password = '';
      _passwordValid = false;
      _updateEnableLoginCreateButtonStream(
          _switchLoginSignUpBtnController.value,
          _emailValid,
          _passwordValid,
          _passwordConfirmationValid);
    });
    passwordConfirmationValid
        .listen((valid) => _updateEnableLoginCreateButtonStream(
            _switchLoginSignUpBtnController.value,
            _emailValid,
            _passwordValid,
            _passwordConfirmationValid))
        .onError((error) {
      _updateEnableLoginCreateButtonStream(
          _switchLoginSignUpBtnController.value,
          _emailValid,
          _passwordValid,
          _passwordConfirmationValid);
    });

    loginOrCreate.listen((action) {
      action is LoginSelectedEvent ? _logIn() : _createAccount();
    });
  }

  void _updateEnableLoginCreateButtonStream(
      DisplayLoginOrSignUpFormEvent displayedPage,
      bool emailValid,
      bool passwordValid,
      bool passwordConfirmationValid) {
    if (displayedPage is DisplayLoginFormEvent) {
      if (emailValid && passwordValid) {
        enableLoginCreateButtonChanged.add(true);
      } else {
        enableLoginCreateButtonChanged.add(false);
      }
    } else if (displayedPage is DisplaySignUpEvent) {
      if (emailValid && passwordValid && passwordConfirmationValid) {
        enableLoginCreateButtonChanged.add(true);
      } else {
        enableLoginCreateButtonChanged.add(false);
      }
    }
  }

  Future<String> _logIn() async {
    String _result = '';
    if (_emailValid && _passwordValid) {
      await authenticationApi
          .logIn(email: _email, password: _password)
          .then((user) {
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
    print("create account");
  }
}
