import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/bool.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/default.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/int.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/list.dart';
import 'package:flutter_bloc_debug/src/widgets/renderers/map.dart';
import 'renderer.dart';
import 'string.dart';

class DebugRenderers extends InheritedWidget {
  final List<ValueRenderer> renderers;

  DebugRenderers({List<ValueRenderer> renderers, @required Widget child})
      : this.renderers = <ValueRenderer>[]
          ..addAll(defaultRenderers)
          ..addAll(renderers ?? {}),
        super(child: child);

  static final List<ValueRenderer> defaultRenderers = [
    StringRenderer(),
    ListRenderer(),
    MapRenderer(),
    BoolRenderer(),
    IntRenderer(),
  ];

  static List<ValueRenderer> of(BuildContext context) {
    final inherited =
        context.inheritFromWidgetOfExactType(DebugRenderers) as DebugRenderers;
    return inherited?.renderers ?? defaultRenderers;
  }

  static Widget build(BuildContext context, dynamic value,
      {bool isDetailled = false}) {
    final renderers = of(context);

    var renderer = renderers.firstWhere((r) => r.support(value),
        orElse: () => null);
    if (renderer == null) {
      renderer = renderer ?? DefaultRenderer();
    }
    return renderer.build(context, value, isDetailled);
  }

  static Future<dynamic> prompt(BuildContext context, String name, Sink sink) {
    final renderers = of(context);
    var renderer =
        renderers.firstWhere((r) => r.support(sink), orElse: () => null);
    if (renderer == null) {
      renderer = renderer ?? DefaultRenderer();
    }
    return renderer.request(context, name);
  }

  @override
  bool updateShouldNotify(DebugRenderers oldWidget) {
    return this.renderers != oldWidget.renderers;
  }
}
