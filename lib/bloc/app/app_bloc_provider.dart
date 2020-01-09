import 'package:flutter/material.dart';

import 'app_bloc.dart';

class AppBlocProvider extends InheritedWidget {
  final AppBloc appBloc;

  const AppBlocProvider(
      {Key key, Widget child, this.appBloc})
      : super(key: key, child: child);

  static AppBlocProvider of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<AppBlocProvider>());
  }

  @override
  bool updateShouldNotify(AppBlocProvider oldWidget) {
    return appBloc != oldWidget.appBloc;
  }
}

