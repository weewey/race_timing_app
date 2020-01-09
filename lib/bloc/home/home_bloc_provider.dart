import 'package:flutter/material.dart';
import 'package:race_timing_app/bloc/home/home_bloc.dart';
import 'package:race_timing_app/models/user.dart';

class HomeBlocProvider extends InheritedWidget {
  final HomeBloc homeBloc;
  final User user;

  const HomeBlocProvider(
      {Key key, Widget child, this.homeBloc, this.user})
      : super(key: key, child: child);

  static HomeBlocProvider of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<HomeBlocProvider>());
  }

  @override
  bool updateShouldNotify(HomeBlocProvider oldWidget) {
    return homeBloc != oldWidget.homeBloc;
  }
}