import 'package:flutter/material.dart';

typedef T FieldValueParser<T>(String value);

class ValueForm extends StatelessWidget {
  final Widget body;
  final GestureTapCallback onSend;

  ValueForm({@required this.body, @required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          this.body,
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: onSend,
              child: Text('Send'),
            ),
          ),
        ],
      ),
    );
  }
}

class ValueFieldForm<T> extends StatefulWidget {
  final FieldValueParser<T> parser;
  final TextInputType keyboardType;

  ValueFieldForm({@required this.parser, this.keyboardType});

  @override
  _FormState createState() {
    return new _FormState();
  }
}

class _FormState extends State<ValueFieldForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ValueForm(
          onSend: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
            }
          },
          body: TextFormField(
            keyboardType: this.widget.keyboardType,
            onSaved: (String value) {
              Navigator.pop(context, this.widget.parser(value));
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter an integer';
              }
            },
          )),
    );
  }
}
