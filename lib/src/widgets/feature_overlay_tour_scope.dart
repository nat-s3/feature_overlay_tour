import 'package:feature_overlay_tour/src/controllers/feature_overlay_tour_controller.dart';
import 'package:flutter/widgets.dart';

/// 表示スコープ
class FeatureOverlayTourScope extends InheritedWidget {
  const FeatureOverlayTourScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final FeatureOverlayTourController controller;

  static FeatureOverlayTourScope of(BuildContext context) {
    final FeatureOverlayTourScope? result = context.dependOnInheritedWidgetOfExactType<FeatureOverlayTourScope>();
    assert(result != null, 'No FeatureOverlayTourScope found in context');
    return result!;
  }

  static FeatureOverlayTourScope once(BuildContext context) {
    final result = context.getElementForInheritedWidgetOfExactType<FeatureOverlayTourScope>()?.widget as FeatureOverlayTourScope?;
    assert(result != null, 'No FeatureOverlayTourScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(FeatureOverlayTourScope oldWidget) {
    return oldWidget.controller != controller;
  }
}
