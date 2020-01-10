import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:race_timing_app/bloc/app/app_bloc_provider.dart';
import 'package:race_timing_app/bloc/login/login_bloc.dart';
import 'package:race_timing_app/bloc/login/login_event.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc _loginBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loginBloc = AppBlocProvider
        .of(context)
        .appBloc
        .loginBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
              child: Icon(
                Icons.account_circle,
                size: 88.0,
                color: Colors.white,
              ),
              preferredSize: Size.fromHeight(40.0)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              padding:
              EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0, bottom: 16.0),
              child: StreamBuilder(
                  initialData: DisplayLoginFormEvent(),
                  stream: _loginBloc.loginOrSignUpBtn,
                  builder: ((BuildContext context, AsyncSnapshot snapshot) {
                    Column form = Column();
                    if (snapshot.data is DisplayLoginFormEvent) {
                      form = _loginForm();
                    } else if (snapshot.data is DisplaySignUpEvent) {
                      form = _signUpForm();
                    }
                    return form;
                  })
              )),
        ));
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  Column _signUpForm() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder(
            stream: _loginBloc.email,
            builder: (BuildContext context, AsyncSnapshot snapshot) =>
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: 'Email Address',
                      icon: Icon(Icons.contact_mail),
                      errorText: snapshot.error),
                  onChanged: _loginBloc.emailChanged.add,
                ),
          ),
          StreamBuilder(
              stream: _loginBloc.password,
              builder: (BuildContext context, AsyncSnapshot snapshot) =>
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.security),
                        errorText: snapshot.error),
                    onChanged: _loginBloc.passwordChanged.add,
                  )),
          StreamBuilder(
              stream: _loginBloc.passwordConfirmationValid,
              builder: (BuildContext context, AsyncSnapshot snapshot) =>
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password Confirmation',
                        icon: Icon(Icons.security),
                        errorText: snapshot.error),
                    onChanged: _loginBloc.passwordConfirmationChanged.add,
                  )),
          SizedBox(height: 48.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder(
                initialData: false,
                stream: _loginBloc.enableLoginCreateButton,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    RaisedButton(
                      elevation: 16.0,
                      child: Text('Create Account'),
                      color: Colors.lightGreen.shade200,
                      disabledColor: Colors.grey.shade100,
                      onPressed: snapshot.data
                          ? () =>
                          _loginBloc.loginOrCreateChanged.add(SignUpSelectedEvent())
                          : null,
                    ),
              ),
              FlatButton(
                child: Text('Login'),
                onPressed: () {
                  _loginBloc.switchLoginSignUpBtn.add(DisplayLoginFormEvent());
                },
              ),
            ],
          ),
        ]
    );
  }

  Column _loginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          stream: _loginBloc.email,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'Email Address',
                    icon: Icon(Icons.contact_mail),
                    errorText: snapshot.error),
                onChanged: _loginBloc.emailChanged.add,
              ),
        ),
        StreamBuilder(
            stream: _loginBloc.password,
            builder: (BuildContext context, AsyncSnapshot snapshot) =>
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.security),
                      errorText: snapshot.error),
                  onChanged: _loginBloc.passwordChanged.add,
                )),
        SizedBox(height: 48.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
              initialData: false,
              stream: _loginBloc.enableLoginCreateButton,
              builder: (BuildContext context, AsyncSnapshot snapshot) =>
                  RaisedButton(
                    elevation: 16.0,
                    child: Text('Login'),
                    color: Colors.lightGreen.shade200,
                    disabledColor: Colors.grey.shade100,
                    onPressed: snapshot.data
                        ? () =>
                        _loginBloc.loginOrCreateChanged.add(LoginSelectedEvent())
                        : null,
                  ),
            ),
            FlatButton(
              child: Text('Create Account'),
              onPressed: () {
                _loginBloc.switchLoginSignUpBtn.add(DisplaySignUpEvent());
              },
            ),
          ],
        ),
      ]
    );
  }
}
