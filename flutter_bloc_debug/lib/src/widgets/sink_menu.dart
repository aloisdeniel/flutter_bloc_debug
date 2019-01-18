import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/debug_renderers.dart';

class SinkMenu extends StatelessWidget {
  final Map<String, Sink<dynamic>> sinks;

  SinkMenu(this.sinks);

  @override
  Widget build(BuildContext context) {
    final entries = this.sinks.entries.toList();
    entries.sort((e1, e2) => e1.key.compareTo(e2.key));
    return Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Container(
            child: ListView(
              children: entries.map((e) => SinkMenuEntry(e)).toList(),
            ),
          ),
        ));
  }
}

class SinkMenuEntry extends StatelessWidget {
  final MapEntry<String, Sink<dynamic>> entry;
  SinkMenuEntry(this.entry);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: RaisedButton(
          child: Text(this.entry.key),
          onPressed: () async {
            final value =
                await DebugRenderers.prompt(context, this.entry.value);
            this.entry.value.add(value);
            Navigator.pop(context);
          },
        ));
  }
}
