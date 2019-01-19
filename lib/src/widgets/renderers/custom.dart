import 'dart:async';

import 'package:flutter/material.dart';
import 'renderer.dart';

typedef FutureOr<T> TypedRequester<T>(BuildContext context);

class CustomValueRenderer<T> extends TypedValueRenderer<T> {
  final TypedRequester<T> requester;

  CustomValueRenderer({@required this.requester});

  @override
  FutureOr<T> typedRequest(BuildContext context) {
    return requester(context);
  }
}