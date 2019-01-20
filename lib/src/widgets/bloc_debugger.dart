import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/history/entry.dart';
import 'package:flutter_bloc_debug/src/widgets/history/history.dart';
import 'package:flutter_bloc_debug/src/widgets/history/stream_entry.dart';
import 'package:flutter_bloc_debug/src/widgets/map_view.dart';
import 'package:rxdart/rxdart.dart';

class BlocDebugger extends StatefulWidget {
  final String title;
  final Map<String, Sink<dynamic>> sinks;
  final Map<String, Stream<dynamic>> streams;
  final bool isActive;
  final Widget child;

  BlocDebugger(
      {@required this.child,
      this.isActive = true,
      this.title,
      this.streams,
      this.sinks});

  BlocDebugger.fromMetadata(
      {@required Map<String, dynamic> metadata, @required Widget child})
      : assert(metadata != null),
        this(
          child: child,
          title: metadata["title"],
          streams: metadata["streams"],
          sinks: metadata["sinks"],
        );

  @override
  State<StatefulWidget> createState() => _BlocDebuggerState();

  static InheritedBlocDebugger of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InheritedBlocDebugger)
        as InheritedBlocDebugger;
  }
}

class _BlocDebuggerState extends State<BlocDebugger> {
  final BehaviorSubject<History> _history =
      BehaviorSubject<History>(sync: true, seedValue: History([]));

  final List<StreamSubscription> _subscription = [];

  StreamBuilder b;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(BlocDebugger oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!this.widget.isActive && oldWidget.isActive) {
      _unsubscribe();
    } else if (this.widget.isActive) {
      var listId = const ListEquality(const IdentityEquality());
      if (oldWidget.isActive &&
          !listId.equals(
              oldWidget.streams?.entries?.map((x) => x.key)?.toList(),
              widget.streams?.entries?.map((x) => x.key)?.toList())) {
        _unsubscribe();
        _subscribe();
      }
    }
  }

  void _subscribe() {
    if (this.widget.streams != null) {
      _subscription.addAll(
          this.widget.streams.entries.map((e) => e.value.listen((newValue) {
                this._history.add(
                    this._history.value.withUpdate({}..[e.key] = newValue));
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
    this._history.close();
    this._unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedBlocDebugger(
        title: this.widget.title,
        sinks: this.widget.sinks,
        isActive: this.widget.isActive,
        streams: this.widget.streams,
        child: this.widget.child,
        history: this._history);
  }
}

class InheritedBlocDebugger extends InheritedWidget {
  final String title;
  final Map<String, Sink<dynamic>> sinks;
  final Map<String, Stream<dynamic>> streams;
  final BehaviorSubject<History> history;
  final bool isActive;

  InheritedBlocDebugger(
      {@required this.title,
      @required this.sinks,
      @required this.streams,
      @required this.history,
      @required this.isActive,
      @required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedBlocDebugger oldWidget) {
    return history != oldWidget.history;
  }
}
