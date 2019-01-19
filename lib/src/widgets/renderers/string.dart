import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/form.dart';
import 'renderer.dart';

class StringRenderer extends TypedValueRenderer<String> {
  @override
  Widget typedBuild(BuildContext context, String value, bool isDetailled) {
    return super.typedBuild(context, "\"$value\"", isDetailled);
  }

  @override
  FutureOr<String> typedRequest(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Theme(
                data: ThemeData.dark(),
                child: Scaffold(
                    body: ValueFieldForm<String>(
                  parser: (v) => v,
                )))));
  }
}
