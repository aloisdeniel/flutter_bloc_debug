import 'package:example/todo_list/blocs/todo_create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/flutter_bloc_debug.dart';

class TodoCreateView extends StatelessWidget {
  final TodoCreateBloc bloc;
  TodoCreateView(this.bloc);
  @override
  Widget build(BuildContext context) {
    return BlocDebugView(
      title: 'CreateTodo',
      streams: {
        'title': this.bloc.title,
        'isChecked': this.bloc.isChecked,
        'created': this.bloc.created,
      },
      sinks: {
        'create': this.bloc.create,
        'updateTitle': this.bloc.updateTitle,
        'updateIsChecked': this.bloc.updateIsChecked,
        'toggle': this.bloc.toggle
      },
    );
  }
}
