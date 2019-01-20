import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/form.dart';
import 'renderer.dart';

class IntRenderer extends TypedValueRenderer<int> {
  @override
  FutureOr<int> typedRequest(BuildContext context, String name) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Theme(
                data: ThemeData.dark(),
                child: Scaffold(
                    body: ValueFieldForm<int>(
                  name: name,
                  hintText: "Enter an integer value",
                  sinkType: "an int",
                  parser: int.parse,
                  keyboardType: TextInputType.number,
                )))));

    //return showDialog<int>(
    //  context: context, builder: (c) => Dialog(child: _Form()));
  }
}
