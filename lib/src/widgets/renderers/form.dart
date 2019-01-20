import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/appbar_title.dart';

typedef T FieldValueParser<T>(String value);

class ValueForm extends StatelessWidget {
  final String name;
  final String sinkType;
  final Widget body;
  final GestureTapCallback onSend;

  ValueForm({@required this.name, @required this.sinkType, @required this.body, @required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: AppBarTitle(
              title: this.name, subtitle: "Send $sinkType to the sink", icon: Icons.publish)),
      body: Padding(
        padding: EdgeInsets.all(16),
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
      ),
    );
  }
}

class ValueFieldForm<T> extends StatefulWidget {
  final FieldValueParser<T> parser;
  final TextInputType keyboardType;
  final String name;
  final String hintText;
  final String sinkType;

  ValueFieldForm(
      {@required this.name, @required this.hintText, @required this.sinkType, @required this.parser, this.keyboardType});

  @override
  _FormState createState() {
    return _FormState();
  }
}

class _FormState extends State<ValueFieldForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ValueForm(
          name: this.widget.name,
          sinkType: this.widget.sinkType,
          onSend: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
            }
          },
          body: TextFormField(
            keyboardType: this.widget.keyboardType,
            decoration: InputDecoration(hintText: this.widget.hintText),
            onSaved: (String value) {
              Navigator.pop(context, this.widget.parser(value));
            },
            validator: (value) {
              if (value.isEmpty) {
                return this.widget.hintText;
              }
            },
          )),
    );
  }
}
