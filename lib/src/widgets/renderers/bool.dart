import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/form.dart';
import 'renderer.dart';

class BoolRenderer extends TypedValueRenderer<bool> {
  @override
  bool get hasDetailled => false;

  @override
  Widget typedBuild(BuildContext context, bool value, bool isDetailled) {
    return Icon((value == true) ? Icons.check_circle : Icons.clear,
        color: Theme.of(context).accentColor);
  }

  @override
  FutureOr<bool> typedRequest(BuildContext context, String name) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Theme(
                data: ThemeData.dark(), child: Scaffold(body: _Form(name)))));
  }
}

class _Form extends StatefulWidget {
  final String name;
  _Form(this.name);
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return ValueForm(
      name: this.widget.name,
      sinkType: "a bool",
      body: Switch(
        value: this.isChecked,
        onChanged: (c) {
          this.setState(() {
            this.isChecked = c;
          });
        },
      ),
      onSend: () {
        Navigator.pop(context, this.isChecked);
      },
    );
  }
}
