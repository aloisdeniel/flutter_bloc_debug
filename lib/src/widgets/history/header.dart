import 'package:flutter/material.dart';

class HistoryHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  HistoryHeader(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.3,
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
        child: Row(
          children: <Widget>[
            Icon(this.icon, size: 16.0),
            SizedBox(width: 7.0),
            Text(this.title, style: TextStyle(fontSize: 12.0)),
          ],
        ),
      ),
    );
  }
}
