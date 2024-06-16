import 'dart:async';

import 'package:feature_overlay_tour/src/model/overlay_layout_model.dart';
import 'package:feature_overlay_tour/src/widgets/fot_scope.dart';
import 'package:flutter/widgets.dart';

class FeatureOverlayTourTarget extends StatefulWidget {
  const FeatureOverlayTourTarget({
    required GlobalKey key,
    this.layoutModel = const TwoCellSquareOverlayLayoutModel(),
    this.shape = const RoundedRectangleBorder(),
    this.backgroundColor = const Color(0xAA000000),
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
  final double? overlayDistanceRatio;
  final OverlayLayoutModel layoutModel;

  final FutureOr<void> Function()? onItemTap;

  final EdgeInsets overlayPadding;

  @override
  State<FeatureOverlayTourTarget> createState() => _FeatureOverlayTourTargetState();
}

class _FeatureOverlayTourTargetState extends State<FeatureOverlayTourTarget> {
  @override
  Widget build(BuildContext context) {
    FOTScope.once(context).controller.registerKey(order: widget.order, key: widget.key as GlobalKey);
    return widget.child;
  }

  @override
  void deactivate() {
    FOTScope.once(context).controller.removeKey(order: widget.order, key: widget.key as GlobalKey);
    super.deactivate();
  }
}
