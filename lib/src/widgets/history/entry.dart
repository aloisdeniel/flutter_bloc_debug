import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_debug/src/widgets/history/stream_entry.dart';

abstract class HistoryEntry  {
  final int index;
  HistoryEntry(this.index);

}

abstract class HistoryEntryView extends StatelessWidget {
  final HistoryEntry entry;
  HistoryEntryView(this.entry, {Key key}) : super(key: key ?? ValueKey(entry.index));
}
