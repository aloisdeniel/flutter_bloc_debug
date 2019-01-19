import 'dart:async';

import 'package:example/todo_list/blocs/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/flutter_bloc_debug.dart';

class TodoListView extends StatelessWidget {
  final TodoListBloc bloc;

  TodoListView(this.bloc);

  @override
  Widget build(BuildContext context) {
    return BlocDebugView(
      title: 'Todo',
      streams: {'items': bloc.items},
      sinks: {'create': bloc.create, 'toggle': bloc.toggle},
    );
  }
}
