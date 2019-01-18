import 'package:example/todo_list/blocs/todo_create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/flutter_bloc_debug.dart';

class TodoCreateView extends StatefulWidget {
  final TodoCreateBloc bloc;
  TodoCreateView(this.bloc);
  @override
  TodoCreateViewState createState() {
    return new TodoCreateViewState();
  }
}

class TodoCreateViewState extends State<TodoCreateView> {

  @override
  void dispose() {
    this.widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocDebugView(
      title: 'CreateTodo',
      streams: {'title': widget.bloc.title},
      sinks: {'create': widget.bloc.create},
    );
  }
}
