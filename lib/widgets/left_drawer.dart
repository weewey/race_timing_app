import 'package:flutter/material.dart';

class LeftDrawerWidget extends StatelessWidget {
  const LeftDrawerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          currentAccountPicture:
              Icon(Icons.face, size: 48.0, color: Colors.white),
          accountEmail: Text('user@example.com'),
          accountName: Text('Test User'),
          otherAccountsPictures: <Widget>[
            Icon(Icons.bookmark_border, color: Colors.white)
          ],
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/home_top_mountain.jpg'),
                  fit: BoxFit.cover)),
        )
      ],
    ));
  }
}
