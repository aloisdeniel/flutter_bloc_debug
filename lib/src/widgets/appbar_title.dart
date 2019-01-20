import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  AppBarTitle(
      {@required this.title, @required this.subtitle, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Opacity(
            opacity: 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(this.icon, size: 12),
                SizedBox(width: 2),
                Text(this.subtitle, style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Text(this.title ?? "Custom"),
        ]);
  }
}
