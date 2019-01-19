import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/divided_column.dart';
import 'map_entry_view.dart';

class UpdateableMap {
  final DateTime lastUpdate;
  final List<UpdateableProperty> properties;

  UpdateableMap(Map<String, dynamic> initial)
      : this.lastUpdate = DateTime.now(),
        this.properties = initial
            .entries
            .map((e) => UpdateableProperty(e.key, e.value, true))
            .toList()..sort((e1,e2) => e1.name.compareTo(e2.name));

  UpdateableMap.fromPrevious(
      UpdateableMap previous, Map<String, dynamic> update)
      : this.lastUpdate = DateTime.now(),
        this.properties = previous.properties.map((old) {
          return update.containsKey(old.name)
                  ? UpdateableProperty(old.name, update[old.name], true)
                  : UpdateableProperty(old.name, old.value, false);
        }).toList();
}

class UpdateableProperty {
  final String name;
  final bool wasUpdated;
  final dynamic value;
  UpdateableProperty(this.name, this.value, this.wasUpdated);
}

class MapView extends StatelessWidget {
  final Widget header;

  final UpdateableMap map;

  final MapPropertyTapped onPropertyTap;

  MapView(
      {@required this.header, @required this.map, this.onPropertyTap, Key key})
      : super(key: key);

  Iterable<Widget> _createChildren(BuildContext context) sync* {
    if (this.header != null) {
      yield this.header;
    }
    for (var entry in this.map.properties) {
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
