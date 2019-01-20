import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/appbar_title.dart';
import 'package:flutter_bloc_debug/src/widgets/bloc_debugger.dart';
import 'package:flutter_bloc_debug/src/widgets/history/history.dart';
import 'package:flutter_bloc_debug/src/widgets/sink_menu.dart';

class BlocDebugDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final debugger = BlocDebugger.of(context);
    return Theme(
        data: ThemeData.dark(),
        child: Drawer(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                actions: <Widget>[
                  SinkMenu(debugger.sinks),
                ],
                title: AppBarTitle(
                    title: debugger.title,
                    subtitle: "Bloc",
                    icon: Icons.layers),
              ),
              StreamBuilder(
                  stream: debugger.history,
                  builder: (c, s) => HistoryView(history: s.data)),
            ],
          ),
        ));
  }
}

class SinkFloadingButton extends StatelessWidget {
  final Map<String, Sink<dynamic>> sinks;

  SinkFloadingButton(this.sinks);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(child: Icon(Icons.keyboard), onPressed: () {});
  }
}
