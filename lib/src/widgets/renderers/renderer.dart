import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class ValueRenderer {
  bool support(dynamic value);

  bool get hasDetailled;

  Widget build(BuildContext context, dynamic value, bool isDetailled);

  FutureOr<dynamic> request(BuildContext context);
}

class TypedValueRenderer<T> extends ValueRenderer {
  Widget build(BuildContext context, dynamic value, bool isDetailled) {
    return typedBuild(context, value as T, isDetailled);
  }

  FutureOr<dynamic> request(BuildContext context) async {
    return await this.typedRequest(context);
  }

  Widget typedBuild(BuildContext context, T value, bool isDetailled) {
    final widget = ValueText(value?.toString() ?? "");

    if (isDetailled) {
      return SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: widget,
      ));
    }

    return widget;
  }

  FutureOr<T> typedRequest(BuildContext context) => null;

  @override
  bool support(dynamic value) {
    return value is Stream<T> ||
        value is Sink<T> ||
        value is T;
  }

  @override
  bool get hasDetailled => true;
}

class ValueText extends StatelessWidget {
  final String text;
  ValueText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(this.text,
        style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor));
  }
}
