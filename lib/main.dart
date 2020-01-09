import 'package:flutter/material.dart';
import 'package:race_timing_app/bloc/app/app_bloc.dart';
import 'package:race_timing_app/bloc/app/app_bloc_provider.dart';
import 'package:race_timing_app/models/user.dart';
import 'package:race_timing_app/pages/home.dart';
import 'package:race_timing_app/pages/login.dart';
import 'package:race_timing_app/services/authentication_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthenticationService _authenticationService =
        AuthenticationService();
    final AppBloc _appBloc = AppBloc(_authenticationService);

    return AppBlocProvider(
      appBloc: _appBloc,
      child: StreamBuilder(
        initialData: null,
        stream: _appBloc.authenticationBloc.user,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data is User) {
            return _buildMaterialApp(Home(),
            );
          } else {
            return _buildMaterialApp(Login());
          }
        },
      ),
    );
  }

  MaterialApp _buildMaterialApp(Widget homePage) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ez-Race',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        canvasColor: Colors.lightBlue.shade50,
        bottomAppBarColor: Colors.lightBlue,
      ),
      home: homePage,
    );
  }


}
