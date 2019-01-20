import 'dart:async';
import 'package:flutter/material.dart';
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

class CounterExample extends StatefulWidget {
  @override
  CounterExampleState createState() {
    return new CounterExampleState();
  }
}

class CounterExampleState extends State<CounterExample> {
  final bloc = CounterBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocDebugger(
      title: 'Counter',
      streams: {'count': this.bloc.count},
      sinks: {'add': this.bloc.add, 'reset': this.bloc.reset},
      child: Scaffold(
          appBar: AppBar(
            title: Text("Counter example"),
          ),
          body: Counter(this.bloc),
          endDrawer: BlocDebugDrawer()),
    );
  }
}

class Counter extends StatefulWidget {
  final CounterBloc bloc;

  Counter(this.bloc);

  @override
  CounterState createState() {
    return new CounterState();
  }
}

class CounterState extends State<Counter> {
  double _addValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.bloc.count,
        builder: (c, s) {
          if (!s.hasData) {
            return Text("no data");
          }

          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Count: ${s.data}",
                    style: Theme.of(context).textTheme.display1),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Slider(
                        value: _addValue,
                        onChanged: (v) {
                          this.setState(() {
                            _addValue = v;
                          });
                        },
                        min: 1.0,
                        max: 5.0,
                        divisions: 4,
                      ),
                      RaisedButton(
                        child: Text("Add $_addValue"),
                        onPressed: () {
                          this.widget.bloc.add.add(this._addValue.toInt());
                        },
                      ),
                      RaisedButton(
                        child: Text("Reset"),
                        onPressed: () {
                          this.widget.bloc.reset.add(null);
                        },
                      ),
                    ]),
              ]);
        });
  }
}
