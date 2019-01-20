import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/map_view.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/debug_renderers.dart';

enum MapEntrySize {
  big,
  small,
}

typedef Future MapPropertyTapped(String title, dynamic value);

class MapEntryView extends StatelessWidget {
  final UpdateableProperty entry;
  final MapPropertyTapped onPropertyTap;
  final bool isUpdateIconVisible;
  final MapEntrySize size;

  MapEntryView(this.entry, {this.size = MapEntrySize.small, @required this.isUpdateIconVisible, this.onPropertyTap})
      : super(key: ValueKey(entry.name));

  void _openDetail(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (c) {
      return Theme(
          data: ThemeData.dark(),
          child: Scaffold(
              appBar: AppBar(title: Text(this.entry.name)),
              body: DebugRenderers.build(context, this.entry.value,
                  isDetailled: true)));
    }));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openDetail(context),
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: (this.isUpdateIconVisible && this.entry.wasUpdated
                      ? Icon(Icons.update, size: this.size == MapEntrySize.big ? 24.0 : 16.0, color: theme.accentColor)
                      : Container()),
                ),
                Expanded(
                    child: Text(this.entry.name,
                        style: this.size == MapEntrySize.big ? theme.textTheme.title : theme.textTheme.subtitle )),
                DebugRenderers.build(context, this.entry.value),
              ],
            )),
      ),
    );
  }
}
