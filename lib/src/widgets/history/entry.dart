import 'package:flutter/widgets.dart';

abstract class HistoryEntry extends StatelessWidget {
  HistoryEntry(int index) : super(key: ValueKey(index));
}
