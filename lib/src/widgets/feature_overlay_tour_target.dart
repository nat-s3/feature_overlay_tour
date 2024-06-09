import 'dart:async';

import 'package:feature_overlay_tour/src/widgets/feature_overlay_tour_scope.dart';
import 'package:flutter/widgets.dart';

class FeatureOverlayTourTarget extends StatefulWidget {
  const FeatureOverlayTourTarget({
    required GlobalKey key,
    this.shape = const RoundedRectangleBorder(),
    this.backgroundColor = const Color(0xAA000000),
    this.curves = Curves.easeInOutQuart,
    this.overlayPadding = EdgeInsets.zero,
    this.overlayDistanceRatio,
    this.onItemTap,
    required this.order,
    required this.overlay,
    required this.child,
  }) : super(key: key);

  final int order;
  final Widget overlay;
  final Widget child;
  final ShapeBorder shape;
  final Color backgroundColor;
  final Curve curves;
  final double? overlayDistanceRatio;

  final FutureOr<void> Function()? onItemTap;

  final EdgeInsets overlayPadding;

  @override
  State<FeatureOverlayTourTarget> createState() => _FeatureOverlayTourTargetState();
}

class _FeatureOverlayTourTargetState extends State<FeatureOverlayTourTarget> {
  @override
  Widget build(BuildContext context) {
    FeatureOverlayTourScope.once(context).controller.registerKey(order: widget.order, key: widget.key as GlobalKey);
    return widget.child;
  }

  @override
  void deactivate() {
    FeatureOverlayTourScope.once(context).controller.removeKey(order: widget.order, key: widget.key as GlobalKey);
    super.deactivate();
  }
}
