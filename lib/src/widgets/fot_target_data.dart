import 'package:feature_overlay_tour/src/model/overlay_layout_model.dart';
import 'package:flutter/widgets.dart';

class FOTTargetData extends InheritedWidget {
  const FOTTargetData({
    super.key,
    required super.child,
    required this.targetRect,
    required this.layoutModel,
    required this.universeRect,
  });

  final OverlayLayoutModel layoutModel;
  final Rect targetRect;
  final Rect universeRect;

  static FOTTargetData of(BuildContext context) {
    final FOTTargetData? result = context.dependOnInheritedWidgetOfExactType<FOTTargetData>();
    assert(result != null, 'No OverlayPositionData found in context');
    return result!;
  }

  static FOTTargetData once(BuildContext context) {
    final result = context.getElementForInheritedWidgetOfExactType<FOTTargetData>()?.widget as FOTTargetData?;
    assert(result != null, 'No FeatureOverlayTourScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(FOTTargetData oldWidget) {
    return oldWidget.targetRect != targetRect || oldWidget.layoutModel != layoutModel || oldWidget.universeRect != universeRect;
  }
}
