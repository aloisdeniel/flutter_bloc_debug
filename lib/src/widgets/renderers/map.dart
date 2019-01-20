import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/map_entry_view.dart';
import 'package:flutter_bloc_debug/src/widgets/map_view.dart';
import 'renderer.dart';

class MapRenderer extends TypedValueRenderer<Map<String,dynamic>> {

  Widget _buildSimple(BuildContext context, Map<String,dynamic> value) {
    return ValueText(value == null ? "null" : "${value.length} items");
  }

  Widget _buildDetailled(BuildContext context, Map<String,dynamic> value) {
    final entries = value.entries.toList();
    return ListView.separated(
      itemCount: value.length,
      separatorBuilder: (c,i) => Divider(),
      itemBuilder: (c,i) => MapEntryView(UpdateableProperty(entries[i].key, entries[i].value, false), isUpdateIconVisible: false,),
    );
  }

  @override
  Widget typedBuild(BuildContext context, Map<String,dynamic> value, bool isDetailled) {
    return isDetailled ? _buildDetailled(context,value) : _buildSimple(context,value);
  }

  @override
  FutureOr<Map<String,dynamic>> typedRequest(BuildContext context, String name) {
    return null;
  }
}