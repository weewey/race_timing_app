import 'package:flutter/material.dart';
import 'package:race_timing_app/bloc/app/app_bloc_provider.dart';
import 'package:race_timing_app/bloc/authentication/authentication_bloc.dart';
import 'package:race_timing_app/widgets/left_drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthenticationBloc _authenticationBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc= AppBlocProvider.of(context).appBloc.authenticationBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ez-Race', style: TextStyle(color: Colors.lightGreen.shade800),),
          elevation: 0.0,
          bottom: PreferredSize(child: Container(), preferredSize: Size.fromHeight(32.0)),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightGreen, Colors.lightGreen.shade50],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.lightGreen.shade800,),
              onPressed: () {
                _authenticationBloc.logoutUser.add(_authenticationBloc.getCurrentUser());
              },
            ),
          ],
        ),
      body: SafeArea(child: Container()),
    );
  }
}
