import 'package:example/todo_list/model/api.dart';
import 'package:example/todo_list/model/todo.dart';
import 'package:example/todo_list/views/todo_list.dart';
import 'package:flutter/material.dart';

class TodoExample extends StatelessWidget {

  final Api api = ListApi(initial: [
      Todo(true, "already did that"),
      Todo(false, "still have to do that"),
    ]);

  @override
  Widget build(BuildContext context) {
    return TodoListExample(this.api);
  }
}