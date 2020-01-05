import 'package:flutter/material.dart';
import 'package:race_timing_app/widgets/left_drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: const LeftDrawerWidget(),
      body: SafeArea(child: Container()),
    );
  }
}
