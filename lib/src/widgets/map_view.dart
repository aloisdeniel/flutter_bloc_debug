import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/divided_column.dart';
import 'map_entry_view.dart';

class UpdateableMap {
  final DateTime lastUpdate;
  final List<UpdateableProperty> properties;

  UpdateableMap(Map<String, dynamic> initial)
      : this.lastUpdate = DateTime.now(),
        this.properties = initial.entries
                  .map((e) => UpdateableProperty(e.key, e.value, true)).toList();

  UpdateableMap.fromPrevious(
      UpdateableMap previous, Map<String, dynamic> update)
      : this.lastUpdate = DateTime.now(),
        this.properties = previous.properties
            .where((old) => !update.containsKey(old.name))
            .map((old) => old.copyWith(wasUpdated: false))
            .toList()
              ..addAll(update.entries
                  .map((e) => UpdateableProperty(e.key, e.value, true)))
              ..sort((x1, x2) => x1.name.compareTo(x2.name));
}

class UpdateableProperty {
  final String name;
  final bool wasUpdated;
  final dynamic value;
  UpdateableProperty(this.name, this.value, this.wasUpdated);

  UpdateableProperty copyWith({String name, dynamic value, bool wasUpdated}) {
    return UpdateableProperty(
        name ?? this.name, value ?? this.value, wasUpdated ?? this.wasUpdated);
  }
}

class MapView extends StatelessWidget {
  final Widget header;
  final bool areUpdateIconsVisible;
  final UpdateableMap map;
  final MapEntrySize entrySize;
  final MapPropertyTapped onPropertyTap;

  MapView(
      {@required this.header,
      this.entrySize = MapEntrySize.small,
      @required this.map,
      this.areUpdateIconsVisible = true,
      this.onPropertyTap,
      Key key})
      : super(key: key);

  Iterable<Widget> _createChildren(BuildContext context) sync* {
    if (this.header != null) {
      yield this.header;
    }
    for (var entry in this.map.properties) {
      yield MapEntryView(entry,
          size: this.entrySize,
          isUpdateIconVisible: this.areUpdateIconsVisible);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DividedColumn(
        children: _createChildren(context).map((w) => w).toList(),
      ),
    );
  }
}
