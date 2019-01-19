import 'dart:async';
import 'package:example/todo_list/model/api.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../model/todo.dart';

class TodoCreateBloc {

  Stream<String> get title => this._title.stream;

  Stream<bool> get isChecked => this._isChecked.stream;

  Sink<String> get updateTitle => this._title.sink;

  Sink<void> get toggle => this._toggle.sink;

  Sink<bool> get updateIsChecked => this._isChecked.sink;

  Sink<void> get create => this._create.sink;

  Stream<Todo> get created => this._created.stream;

  final BehaviorSubject<String> _title =
      BehaviorSubject<String>(sync: true, seedValue: "My new task!");

  final BehaviorSubject<bool> _isChecked =
      BehaviorSubject<bool>(sync: true, seedValue: false);

  final PublishSubject<Todo> _created = PublishSubject<Todo>(
    sync: true,
  );

  final PublishSubject<void> _create = PublishSubject<void>(
    sync: true,
  );

  final PublishSubject<void> _toggle = PublishSubject<void>(
    sync: true,
  );

  List<StreamSubscription> subscriptions;

  List<Subject> subjects;

  TodoCreateBloc() {
    subscriptions = [
      this._create.listen((_) => _onCreate()),
      this._toggle.listen((_) => _onToggle()),
    ];
    subjects = [
      this._created,
      this._title,
      this._isChecked,
    ];
  }

  void _onCreate() {
      this._created.add(Todo(this._isChecked.value, this._title.value));
  }

  void _onToggle() {
      this._isChecked.add(!this._isChecked.value);
  }

  @mustCallSuper
  void dispose() {
    this.subjects.forEach((s) => s.close());
    this.subscriptions.forEach((s) => s.cancel());
  }
}
