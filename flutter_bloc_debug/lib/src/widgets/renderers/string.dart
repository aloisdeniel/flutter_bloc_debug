import 'dart:async';

import 'package:flutter/material.dart';
import 'renderer.dart';

class StringRenderer extends TypedValueRenderer<String> {
  @override
  Widget typedBuild(BuildContext context, String value, bool isDetailled) {
    return super.typedBuild(context, "\"$value\"", isDetailled);
  }

  @override
  FutureOr<String> typedRequest(BuildContext context) {
    return null;
  }
}
