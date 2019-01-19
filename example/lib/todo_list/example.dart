import 'dart:async';

import 'package:example/todo_list/blocs/todo_create.dart';
import 'package:example/todo_list/blocs/todo_list.dart';
import 'package:example/todo_list/model/api.dart';
import 'package:example/todo_list/model/todo.dart';
import 'package:example/todo_list/views/todo_create.dart';
import 'package:example/todo_list/views/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/flutter_bloc_debug.dart';

class TodoExample extends StatefulWidget {
  @override
  TodoExampleState createState() {
    return TodoExampleState();
  }
}

class TodoExampleState extends State<TodoExample> {
  final Api api;
  TodoListBloc listBloc;

  TodoExampleState._({@required this.api});

  factory TodoExampleState() {
    final api = ListApi(initial: [
      Todo(true, "already did that"),
      Todo(false, "still have to do that"),
    ]);
    return TodoExampleState._(api: api);
  }

  static Future<Todo> _requestTodo(BuildContext context) async {
    final bloc = TodoCreateBloc();
    final completer = Completer<Todo>();
    final subscription = bloc.created.listen((todo) {
      if (todo != null) {
        completer.complete(todo);
      }
    });

    Navigator.of(context).push(MaterialPageRoute(
      builder: (c) => TodoCreateView(bloc),
    ));

    final result = await completer.future;

    // Disposing
    subscription.cancel();
    bloc.dispose();
    Navigator.pop(context);

    return result;
  }

  @override
  void initState() {
    this.listBloc = TodoListBloc(api);
    super.initState();
  }

  @override
  void dispose() {
    this.listBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DebugRenderers(
        renderers: [
          CustomValueRenderer(requester: _requestTodo),
        ],
        child: Scaffold(
            appBar: AppBar(
              title: Text("Todo example"),
            ),
            body: Center(child: Text("Open debug drawer from right")),
            endDrawer: TodoListView(this.listBloc)));
  }
}
