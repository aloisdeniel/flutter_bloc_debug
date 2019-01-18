import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/divided_column.dart';
import 'map_entry_view.dart';

class MapView extends StatelessWidget {
  final Widget header;

  final Map<String, dynamic> map;

  final MapPropertyTapped onPropertyTap;

  MapView(
      {@required this.header, @required this.map, this.onPropertyTap, Key key})
      : super(key: key);

  Iterable<Widget> _createChildren(BuildContext context) sync* {
    if (this.header != null) {
      yield this.header;
    }
    final entries = this.map.entries.toList();
    entries.sort((e1, e2) => e1.key.compareTo(e2.key));
    for (var entry in entries) {
      yield MapEntryView(entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DividedColumn(
        children: _createChildren(context)
            .map((w) => w)
            .toList(),
      ),
    );
  }
}
