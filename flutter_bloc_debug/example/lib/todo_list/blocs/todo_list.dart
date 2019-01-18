import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_debug/flutter_bloc_debug.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../model/todo.dart';

class TodoListBloc {
  Stream<List<Todo>> get items => this._items.stream;

  Sink<Todo> get create => this._create.sink;

  final PublishSubject<Todo> _create = PublishSubject<Todo>(sync: true);

  Sink<int> get toggle => this._toggle.sink;

  final PublishSubject<int> _toggle = PublishSubject<int>(sync: true);

  final BehaviorSubject<List<Todo>> _items =
      BehaviorSubject<List<Todo>>(sync: true, seedValue: [
    Todo(true, "test 1"),
    Todo(false, "this one is not done"),
  ]);

  List<StreamSubscription> subscriptions;

  List<Subject> subjects;

  TodoListBloc() {
    subscriptions = [
      this._create.listen(_onCreate),
      this._toggle.listen(_onToggle),
    ];
    subjects = [
      this._create,
      this._toggle,
      this._items,
    ];
  }

  void _onCreate(Todo value) {}

  void _onToggle(int value) {
    final newItems = this._items.value.asMap().entries.map((e) {
      if(e.key == value) {
        return Todo(!e.value.done, e.value.title);
      }
      return e.value;
    }).toList();

    this._items.add(newItems);
  }

  @mustCallSuper
  void dispose() {
    this.subjects.forEach((s) => s.close());
    this.subscriptions.forEach((s) => s.cancel());
  }
}