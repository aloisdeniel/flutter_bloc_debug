import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/map_view.dart';
import 'package:flutter_bloc_debug/src/widgets/sink_menu.dart';

class BlocDebugView extends StatefulWidget {
  final String title;
  final Map<String, Sink<dynamic>> sinks;
  final Map<String, Stream<dynamic>> streams;

  BlocDebugView({this.title, this.streams, this.sinks});

  @override
  State<StatefulWidget> createState() => _BlocDebugViewState();
}

class _BlocDebugViewState extends State<BlocDebugView> {
  Map<String, dynamic> _state = {};
  DateTime lastUpdate = DateTime.now();

  final List<StreamSubscription> _subscription = [];

  StreamBuilder b;

  @override
  void initState() {
    super.initState();
    this._state = this.widget.streams.map((k, v) => MapEntry(k, null));
    _subscribe();
  }

  @override
  void didUpdateWidget(BlocDebugView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streams != widget.streams) {
      if (_subscription != null) {
        _unsubscribe();
      }
      _subscribe();
    }
  }

  void _subscribe() {
    if (this.widget.streams != null) {
      _subscription.addAll(
          this.widget.streams.entries.map((e) => e.value.listen((newValue) {
                this.setState(() {
                  this.lastUpdate = DateTime.now();
                  this._state = {}
                    ..addAll(_state)
                    ..[e.key] = newValue;
                });
              })));
    }
  }

  void _unsubscribe() {
    if (this._subscription.isNotEmpty) {
      this._subscription.forEach((s) => s.cancel());
      this._subscription.clear();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.widget.title ?? "Bloc")),
      floatingActionButton: SinkFloadingButton(this.widget.sinks),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: MapView(
            map: this._state,
            header: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    "Updated at ${lastUpdate.hour}:${lastUpdate.second}:${lastUpdate.millisecond}",
                    style: TextStyle(fontSize: 10.0, color: Colors.grey))),
            onPropertyTap: (key, value) {},
          ),
        ),
      ),
    );
  }
}

class SinkFloadingButton extends StatelessWidget {
  final Map<String, Sink<dynamic>> sinks;

  SinkFloadingButton(this.sinks);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.keyboard),
        onPressed: () => showDialog(
            context: context,
            builder: (c) => Dialog(child: SinkMenu(this.sinks))));
  }
}
