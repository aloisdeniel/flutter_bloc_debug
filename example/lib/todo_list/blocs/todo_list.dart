import 'dart:async';
import 'package:example/todo_list/model/api.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../model/todo.dart';

class TodoListBloc {
  final Api _api;

  Stream<List<Todo>> get items => this._items.stream;

  Sink<Todo> get create => this._create.sink;

  final PublishSubject<Todo> _create = PublishSubject<Todo>(sync: true);

  Sink<int> get toggle => this._toggle.sink;

  final PublishSubject<int> _toggle = PublishSubject<int>(sync: true);

  BehaviorSubject<List<Todo>> _items;

  List<StreamSubscription> subscriptions;

  List<Subject> subjects;

  TodoListBloc(this._api) {
    _items = BehaviorSubject<List<Todo>>(sync: true, seedValue: []);

    subscriptions = [
      this._create.listen(_onCreate),
      this._toggle.listen(_onToggle),
    ];
    subjects = [
      this._create,
      this._toggle,
      this._items,
    ];

    this._updateAll();
  }

  Future<void> _updateAll() async {
    final all = await this._api.all;
    this._items.add(all);
  }

  Future<void> _onCreate(Todo value) async {
    if (value != null) {
      final newItems = List<Todo>.from(this._items.value)..add(value);
      this._items.add(newItems);
      await this._api.add(value);
    }
  }

  Future<void> _onToggle(int value) async {
    final todo = this._items.value.elementAt(value);
    final newTodo = await this._api.toggle(todo);
    final newItems = List<Todo>.from(this._items.value)
      ..replaceRange(value, value, [newTodo]);
    this._items.add(newItems);
  }

  @mustCallSuper
  void dispose() {
    this.subjects.forEach((s) => s.close());
    this.subscriptions.forEach((s) => s.cancel());
  }
}
