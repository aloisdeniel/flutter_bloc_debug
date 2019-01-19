import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/history/entry.dart';
import 'package:flutter_bloc_debug/src/widgets/map_view.dart';

class StreamHistoryEntry extends HistoryEntry {
  final UpdateableMap state;

  StreamHistoryEntry(int index, this.state) : super(index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: MapView(
        map: this.state,
        header: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
                "Updated at ${this.state.lastUpdate.hour}:${this.state.lastUpdate.second}:${this.state.lastUpdate.millisecond}",
                style: TextStyle(fontSize: 10.0, color: Colors.grey))),
        onPropertyTap: (key, value) {},
      ),
    );
  }
}
