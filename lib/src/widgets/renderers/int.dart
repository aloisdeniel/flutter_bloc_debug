import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/form.dart';
import 'renderer.dart';

class IntRenderer extends TypedValueRenderer<int> {
  @override
  FutureOr<int> typedRequest(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Scaffold(
                    body: ValueFieldForm<int>(
                  parser: int.parse,
                  keyboardType: TextInputType.number,
                ))));

    //return showDialog<int>(
    //  context: context, builder: (c) => Dialog(child: _Form()));
  }
}
