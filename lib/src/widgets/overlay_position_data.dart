import 'package:flutter/widgets.dart';

class OverlayPositionData extends InheritedWidget {
  const OverlayPositionData({
    super.key,
    required super.child,
    required this.targetLocalCenter,
    required this.targetSize,
    required this.constraint,
    required this.overlayOffset,
  });

  /// 左上を原点とした、targetの相対的な表示位置を示します
  final Offset targetLocalCenter;
  final Size targetSize;
  final BoxConstraints constraint;
  final Offset overlayOffset;

  static OverlayPositionData of(BuildContext context) {
    final OverlayPositionData? result = context.dependOnInheritedWidgetOfExactType<OverlayPositionData>();
    assert(result != null, 'No OverlayPositionData found in context');
    return result!;
  }

  static OverlayPositionData once(BuildContext context) {
    final result = context.getElementForInheritedWidgetOfExactType<OverlayPositionData>()?.widget as OverlayPositionData?;
    assert(result != null, 'No FeatureOverlayTourScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(OverlayPositionData oldWidget) {
    return oldWidget.targetLocalCenter != targetLocalCenter;
  }
}
