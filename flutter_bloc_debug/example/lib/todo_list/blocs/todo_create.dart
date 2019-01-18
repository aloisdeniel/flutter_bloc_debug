import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../model/todo.dart';

class TodoCreateBloc {
  Stream<String> get title => this._title.stream;

  Stream<Todo> get created => this._created.stream;

  final BehaviorSubject<String> _title =
      BehaviorSubject<String>(sync: true, seedValue: "My new task!");

  final PublishSubject<Todo> _created = PublishSubject<Todo>(
    sync: true,
  );

  Sink<void> get create => this._create.sink;

  final PublishSubject<void> _create = PublishSubject<void>(sync: true);

  List<StreamSubscription> subscriptions;

  List<Subject> subjects;

  TodoListBloc() {
    subscriptions = [
      this._create.listen(_onCreate),
    ];
    subjects = [
      this._create,
      this._created,
      this._title,
    ];
  }

  void _onCreate(Todo value) {
      this._created.add(Todo(false, this._title.value));
  }

  @mustCallSuper
  void dispose() {
    this.subjects.forEach((s) => s.close());
    this.subscriptions.forEach((s) => s.cancel());
  }
}
