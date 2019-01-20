import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/history/entry.dart';
import 'package:flutter_bloc_debug/src/widgets/map_entry_view.dart';
import 'package:flutter_bloc_debug/src/widgets/map_view.dart';

class StreamHistoryEntry extends HistoryEntry {
  final UpdateableMap state;
  StreamHistoryEntry(int index, this.state) : super(index);
}

class StreamHistoryEntryView extends HistoryEntryView {
  final bool isHeaderVisible;
  final bool areUpdatesVisible;

  StreamHistoryEntryView(StreamHistoryEntry entry,
      {Key key, this.areUpdatesVisible = true, this.isHeaderVisible = true})
      : super(entry, key: key);

  @override
  Widget build(BuildContext context) {
    final entry = this.entry as StreamHistoryEntry;
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: MapView(
        map: entry.state,
        entrySize: this.isHeaderVisible ? MapEntrySize.small : MapEntrySize.big,
        areUpdateIconsVisible: this.areUpdatesVisible,
        header: !this.isHeaderVisible
            ? null
            : Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    "${entry.state.properties.isEmpty ? "Created" : "Updated"} at ${entry.state.lastUpdate.hour}:${entry.state.lastUpdate.second}:${entry.state.lastUpdate.millisecond}",
                    style: TextStyle(fontSize: 10.0, color: Colors.grey))),
        onPropertyTap: (key, value) {},
      ),
    );
  }
}
