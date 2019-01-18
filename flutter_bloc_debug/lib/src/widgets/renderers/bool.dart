import 'dart:async';

import 'package:flutter/material.dart';
import 'renderer.dart';

class BoolRenderer extends TypedValueRenderer<bool> {

  @override
  bool get hasDetailled => false;

  @override
  Widget typedBuild(BuildContext context, bool value, bool isDetailled) {
    return Icon((value == true) ? Icons.check_circle : Icons.clear,
        color: Theme.of(context).accentColor);
  }

  @override
  FutureOr<bool> typedRequest(BuildContext context) {

    return null;
  }
}