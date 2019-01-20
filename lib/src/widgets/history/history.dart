import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/history/entry.dart';
import 'package:flutter_bloc_debug/src/widgets/history/header.dart';
import 'package:flutter_bloc_debug/src/widgets/history/stream_entry.dart';
import 'package:flutter_bloc_debug/src/widgets/map_view.dart';

class History {
  final List<HistoryEntry> entries;
  History(this.entries);

  History withUpdate(Map<String, dynamic> update) {
    if (this.entries.isEmpty) {
      return History([StreamHistoryEntry(0, UpdateableMap(update))]);
    }

    final previous = this.entries.firstWhere((x) => x is StreamHistoryEntry)
        as StreamHistoryEntry;

    return History(List<HistoryEntry>.from(this.entries)
      ..insert(
          0,
          StreamHistoryEntry(this.entries.length + 1,
              UpdateableMap.fromPrevious(previous?.state, update))));
  }
}

class HistoryView extends StatelessWidget {
  final History history;

  HistoryView({@required this.history});

  Iterable<Widget> _generateChildren(BuildContext context) sync* {
    if (this.history != null) {
      final lastState = history.entries
              .firstWhere((x) => x is StreamHistoryEntry, orElse: () => null)
          as StreamHistoryEntry;
      if (lastState != null) {
        yield HistoryHeader("Last received values from streams", Icons.camera);
        yield StreamHistoryEntryView(lastState,
            key: ValueKey("lastUpdate"),
            areUpdatesVisible: false,
            isHeaderVisible: false);
      }
      
      yield HistoryHeader("History of updates", Icons.history);

      yield* history.entries.map((entry) {
        if (entry is StreamHistoryEntry) {
          return StreamHistoryEntryView(entry);
        }
        throw Exception("Unsupported entry type");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate(_generateChildren(context).toList()));
  }
}
