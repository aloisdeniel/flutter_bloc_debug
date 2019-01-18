import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_debug/flutter_bloc_debug.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class CounterBloc {
  Sink<int> get add => this._add.sink;

  Sink<void> get reset => this._reset.sink;

  Stream<int> get count => this._count.stream;

  final PublishSubject<void> _reset = PublishSubject<void>(sync: true);

  final PublishSubject<int> _add = PublishSubject<int>(sync: true);

  final BehaviorSubject<int> _count =
      BehaviorSubject<int>(sync: true, seedValue: 0);

  List<StreamSubscription> subscriptions;

  List<Subject> subjects;

  CounterBloc() {
    subscriptions = [
      this._add.listen(_onAdd),
      this._reset.listen((_) => _onReset()),
    ];
    subjects = [
      this._add,
      this._count,
      this._reset,
    ];
  }

  void _onAdd(int value) {
    this._count.add(this._count.value + value);
  }

  void _onReset() {
    this._count.add(0);
  }

  @mustCallSuper
  void dispose() {
    this.subjects.forEach((s) => s.close());
    this.subscriptions.forEach((s) => s.cancel());
  }
}

class CounterView extends StatefulWidget {
  @override
  CounterViewState createState() {
    return new CounterViewState();
  }
}

class CounterViewState extends State<CounterView> {
  final bloc = CounterBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocDebugView(
      title: 'Counter',
      streams: {'count': bloc.count},
      sinks: {'add': bloc.add, 'reset': bloc.reset},
    );
  }
}
