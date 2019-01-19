import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/map.dart';
import 'renderer.dart';

class ListRenderer extends TypedValueRenderer<List> {

  static final mapRenderer = MapRenderer();

  @override
  Widget typedBuild(BuildContext context, List value, bool isDetailled) {
    return mapRenderer.typedBuild(context, value.asMap().map((k,v) => MapEntry(k?.toString(), v)), isDetailled);
  }

  @override
  FutureOr<List> typedRequest(BuildContext context) {
    return null;
  }
}