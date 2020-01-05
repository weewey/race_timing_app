import 'package:race_timing_app/bloc/base_bloc.dart';
import 'package:race_timing_app/services/authentication_api.dart';

class HomeBloc implements BaseBloc {
  final AuthenticationApi authenticationApi;


  HomeBloc(this.authenticationApi) {
    _startListeners();
  }

  void dispose() {
  }

  void _startListeners() {
  }
}