import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/debug_renderers.dart';

typedef Future MapPropertyTapped(String title, dynamic value);

class MapEntryView extends StatelessWidget {
  final MapEntry<String, dynamic> entry;

  final MapPropertyTapped onPropertyTap;

  MapEntryView(this.entry, {this.onPropertyTap})
      : super(key: ValueKey(entry.key));

  void _openDetail(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (c) {
      return Scaffold(
          appBar: AppBar(title: Text(this.entry.key)),
          body: DebugRenderers.build(context, this.entry.value,
              isDetailled: true));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openDetail(context),
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(this.entry.key,
                    style: TextStyle(color: Colors.black, fontSize: 12.0)),
                DebugRenderers.build(context, this.entry.value),
              ],
            )),
      ),
    );
  }
}
