import 'package:feature_overlay_tour/src/controllers/fot_controller.dart';
import 'package:flutter/widgets.dart';

/// 表示スコープ
class FOTScope extends InheritedWidget {
  const FOTScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final FOTController controller;

  static FOTScope of(BuildContext context) {
    final FOTScope? result = context.dependOnInheritedWidgetOfExactType<FOTScope>();
    assert(result != null, 'No FeatureOverlayTourScope found in context');
    return result!;
  }

  static FOTScope once(BuildContext context) {
    final result = context.getElementForInheritedWidgetOfExactType<FOTScope>()?.widget as FOTScope?;
    assert(result != null, 'No FeatureOverlayTourScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(FOTScope oldWidget) {
    return oldWidget.controller != controller;
  }
}
