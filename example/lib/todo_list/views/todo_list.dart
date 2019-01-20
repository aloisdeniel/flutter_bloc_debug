import 'dart:async';

import 'package:example/todo_list/blocs/todo_list.dart';
import 'package:example/todo_list/model/api.dart';
import 'package:example/todo_list/model/todo.dart';
import 'package:example/todo_list/views/todo_create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/flutter_bloc_debug.dart';

class TodoListExample extends StatefulWidget {

  final Api api;
  TodoListExample(this.api);

  @override
  TodoListExampleState createState() {
    return TodoListExampleState();
  }
}

class TodoListExampleState extends State<TodoListExample> {
  
  TodoListBloc bloc;
  StreamSubscription _subscription;

  @override
  void initState() {
    this.bloc = TodoListBloc(this.widget.api);
    _subscription = this.bloc.creationRequested.listen((_) async {
      await Navigator.push(this.context, MaterialPageRoute(
        builder: (c) => TodoCreateExample(this.widget.api)
      ));
      this.bloc.refresh.add(null);
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
          'items': this.bloc.items,
          'creationRequested': this.bloc.creationRequested
        },
        sinks: {'create': this.bloc.create, 'toggle': this.bloc.toggle},
        child: Scaffold(
            appBar: AppBar(
              title: Text("Todo example"),
            ),
            body: Center(child: TodoListView(this.bloc)),
            endDrawer: BlocDebugDrawer()));
  }
}

class TodoListView extends StatelessWidget {
  final TodoListBloc bloc;

  TodoListView(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
        stream: bloc.items,
        builder: (c, snapshot) => ListView(
            children: !snapshot.hasData
                ? []
                : snapshot.data
                    .asMap()
                    .entries
                    .map((x) => TodoCellView(x.key, x.value, this.bloc))
                    .toList()));
  }
}

class TodoCellView extends StatelessWidget {
  final Todo model;
  final int index;
  final TodoListBloc bloc;

  TodoCellView(this.index, this.model, this.bloc);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => bloc.toggle.add(this.index),
      leading: Container(
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(4.0)),
          width: 24,
          height: 24,
          child: this.model.done ? Icon(Icons.check) : SizedBox()),
      title: Text(this.model.title),
    );
  }
}
