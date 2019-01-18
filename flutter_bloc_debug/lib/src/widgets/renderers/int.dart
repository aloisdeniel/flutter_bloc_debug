import 'dart:async';

import 'package:flutter/material.dart';
import 'renderer.dart';

class IntRenderer extends TypedValueRenderer<int> {
  @override
  FutureOr<int> typedRequest(BuildContext context) {

    return Navigator.push(context, MaterialPageRoute(builder: (c) => Scaffold(body: _Form())));

    //return showDialog<int>(
      //  context: context, builder: (c) => Dialog(child: _Form()));
  }
}

class _Form extends StatefulWidget {
  @override
  _FormState createState() {
    return new _FormState();
  }
}

class _FormState extends State<_Form> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              onSaved: (String value) {
                Navigator.pop(context, int.parse(value));
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter an integer';
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                  }
                },
                child: Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
