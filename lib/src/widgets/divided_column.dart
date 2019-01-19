import 'package:flutter/material.dart';

class DividedColumn extends StatelessWidget {
  final List<Widget> children;
  final IndexedWidgetBuilder dividerBuilder;
  DividedColumn({@required this.children, IndexedWidgetBuilder dividerBuilder, Key key})
      : this.dividerBuilder = dividerBuilder ?? ((c,i) => Divider(height: 1 )), super(key: key);

  Iterable<Widget> _createChildren(BuildContext context) sync* {
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        yield dividerBuilder(context, i);
      }
      yield children[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: this._createChildren(context).toList(),
    );
  }
}
