import 'dart:async';

import 'package:flutter/material.dart';
import 'package:collection/equality.dart';
import 'package:flutter_bloc_debug/src/widgets/history/entry.dart';
import 'package:flutter_bloc_debug/src/widgets/history/stream_entry.dart';
import 'package:flutter_bloc_debug/src/widgets/map_view.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/debug_renderers.dart';
import 'package:flutter_bloc_debug/src/widgets/sink_menu.dart';

class BlocDebugView extends StatefulWidget {
  final String title;
  final Map<String, Sink<dynamic>> sinks;
  final Map<String, Stream<dynamic>> streams;

  BlocDebugView({this.title, this.streams, this.sinks});

  BlocDebugView.fromMetadata(Map<String, dynamic> metadata)
      : this(
          title: metadata["title"],
          streams: metadata["streams"],
          sinks: metadata["sinks"],
        );

  @override
  State<StatefulWidget> createState() => _BlocDebugViewState();
}

class _BlocDebugViewState extends State<BlocDebugView> {
  List<HistoryEntry> _history = [];

  final List<StreamSubscription> _subscription = [];

  StreamBuilder b;

  @override
  void initState() {
    super.initState();
    this._history.add(StreamHistoryEntry(0,
        UpdateableMap(this.widget.streams.map((k, v) => MapEntry(k, null)))));
    _subscribe();
  }

  void _update(Map<String, dynamic> update) {
    final previous = this._history.firstWhere((x) => x is StreamHistoryEntry)
        as StreamHistoryEntry;
    this.setState(() {
      this._history = List<HistoryEntry>.from(this._history)
        ..insert(
            0,
            StreamHistoryEntry(this._history.length + 1,
                UpdateableMap.fromPrevious(previous?.state, update)));
    });
  }

  @override
  void didUpdateWidget(BlocDebugView oldWidget) {
    super.didUpdateWidget(oldWidget);

    var listId = const ListEquality(const IdentityEquality());
    if (!listId.equals(oldWidget.streams?.entries?.map((x) => x.key)?.toList(),
        widget.streams?.entries?.map((x) => x.key)?.toList())) {
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
                  this._update({}..[e.key] = newValue);
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
    return Theme(
        data: ThemeData.dark(),
        child: Drawer(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      final renderers = DebugRenderers.of(context);
                      showDialog(
                          context: context,
                          builder: (c) => DebugRenderers(
                              renderers: renderers,
                              child: Dialog(child: SinkMenu(this.widget.sinks))));
                    },
                    icon: Icon(Icons.keyboard))
                ],
                title: Text(this.widget.title ?? "Bloc"),
              ),
              SliverList(delegate: SliverChildListDelegate(this._history)),
            ],
          ),
        ));
  }
}

class SinkFloadingButton extends StatelessWidget {
  final Map<String, Sink<dynamic>> sinks;

  SinkFloadingButton(this.sinks);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(child: Icon(Icons.keyboard), onPressed: () {});
  }
}
