import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/debug_renderers.dart';

class SinkMenu extends StatelessWidget {
  final Map<String, Sink<dynamic>> sinks;

  SinkMenu(this.sinks);

  Iterable<PopupMenuEntry<MapEntry<String, Sink<dynamic>>>> _buildItems(
      BuildContext context) sync* {
    final entries = this.sinks.entries.toList();

    yield PopupMenuItem(
      enabled: false,
      child: Text("Sinks", style: TextStyle(fontSize: 12)));

    yield PopupMenuDivider();

    yield* entries.map((e) => PopupMenuItem<MapEntry<String, Sink<dynamic>>>(
          value: e,
          child: ListTile(title: Text(e.key)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MapEntry<String, Sink<dynamic>>>(
      onSelected: (MapEntry<String, Sink<dynamic>> entry) async {
        final value =
            await DebugRenderers.prompt(context, entry.key, entry.value);
        entry.value.add(value);
      },
      itemBuilder: (BuildContext context) => _buildItems(context).toList(),
    );
  }
}
