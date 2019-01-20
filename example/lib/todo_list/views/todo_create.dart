import 'dart:async';

import 'package:example/todo_list/blocs/todo_create.dart';
import 'package:example/todo_list/model/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/flutter_bloc_debug.dart';

class TodoCreateExample extends StatefulWidget {
  final Api api;
  TodoCreateExample(this.api);

  @override
  TodoCreateExampleState createState() {
    return TodoCreateExampleState();
  }
}

class TodoCreateExampleState extends State<TodoCreateExample> {
  TodoCreateBloc bloc;
  StreamSubscription _subscription;

  @override
  void initState() {
    this.bloc = TodoCreateBloc(this.widget.api);
    _subscription = this.bloc.created.listen((_) {
      Navigator.pop(this.context);
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    this.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocDebugger(
        title: 'Todo',
        streams: {
          'title': this.bloc.title,
          'isChecked': this.bloc.isChecked,
          'created': this.bloc.created,
        },
        sinks: {
          'updateTitle': this.bloc.updateTitle,
          'updateIsChecked': this.bloc.updateIsChecked,
          'create': this.bloc.create
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Todo example"),
            ),
            body: Center(child: TodoCreateView(this.bloc)),
            endDrawer: BlocDebugDrawer()));
  }
}

class TodoCreateView extends StatelessWidget {
  final TodoCreateBloc bloc;
  TodoCreateView(this.bloc);
  @override
  Widget build(BuildContext context) {
    return Text("TODO");
  }
}
