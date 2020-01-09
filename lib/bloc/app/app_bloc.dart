import 'package:race_timing_app/bloc/authentication/authentication_bloc.dart';
import 'package:race_timing_app/bloc/base_bloc.dart';
import 'package:race_timing_app/bloc/login/login_bloc.dart';
import 'package:race_timing_app/models/user.dart';
import 'package:race_timing_app/services/authentication_api.dart';

class AppBloc implements BaseBloc {
  final AuthenticationApi authenticationApi;
  AuthenticationBloc _authenticationBloc;
  LoginBloc _loginBloc;

  AppBloc(this.authenticationApi){
    _authenticationBloc = AuthenticationBloc(authenticationApi);
    _loginBloc = LoginBloc(authenticationApi);
    _loginBloc.getLoggedInUser.listen((user){
      if(user is User){
        _authenticationBloc.addUser.add(user);
      }
    });
  }

  AuthenticationBloc get authenticationBloc => _authenticationBloc;
  LoginBloc get loginBloc => _loginBloc;

  @override
  void dispose() {
    _authenticationBloc.dispose();
  }

}