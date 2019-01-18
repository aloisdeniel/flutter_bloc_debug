import 'dart:async';

import 'package:example/todo_list/blocs/todo_create.dart';
import 'package:example/todo_list/blocs/todo_list.dart';
import 'package:example/todo_list/model/todo.dart';
import 'package:example/todo_list/views/todo_create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/flutter_bloc_debug.dart';
import 'package:rxdart/rxdart.dart';

class TodoListView extends StatefulWidget {
  @override
  TodoListViewState createState() {
    return new TodoListViewState();
  }
}

class TodoListViewState extends State<TodoListView> {
  final bloc = TodoListBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  static Future _requestTodo(BuildContext context) async {
    final bloc = TodoCreateBloc();
    final completer = Completer<Todo>();
    final subscription = bloc.created.listen((todo) {
      if (todo != null) {
        completer.complete(todo);
        Navigator.pop(context);
      }
    });

    Navigator.of(context).push(MaterialPageRoute(
      builder: (c) => TodoCreateView(bloc),
    ));

    final result = await completer.future;
    subscription.cancel();
    return result;
  }

  Type _typeof<T>() => T;

  @override
  Widget build(BuildContext context) {
    return BlocDebugView(
      title: 'Todo',
      streams: {'items': bloc.items},
      sinks: {'create': bloc.create, 'toggle': bloc.toggle},
    );
  }
}
