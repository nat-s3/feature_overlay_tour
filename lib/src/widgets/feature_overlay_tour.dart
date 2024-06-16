import 'package:flutter/material.dart';

import '../../feature_overlay_tour.dart';
import '../values/feature_overlay_tour_state.dart';
import 'fot_overlay_view.dart';

class FeatureOverlayTour extends StatefulWidget {
  const FeatureOverlayTour({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<FeatureOverlayTour> createState() => _FeatureOverlayTourState2();

  static FOTScope of(BuildContext context) =>
      FOTScope.of(context);

  static FOTScope once(BuildContext context) =>
      FOTScope.once(context);

}

class _FeatureOverlayTourState2 extends State<FeatureOverlayTour> {
  // AnimationController? animateController;
  FOTController? controller;

  FeatureOverlayTourState? lastState;

  OverlayEntry? entry;

  @override
  void initState() {
    final tourCon = FOTController();
    controller = tourCon;

    lastState = tourCon.state.value;
    tourCon.state.addListener(_stateListener);
    super.initState();
  }

  @override
  void dispose() {
    controller?.state.removeListener(_stateListener);
    lastState = null;
    entry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const Center();
    }

    return FOTScope(
      controller: controller!,
      child: widget.child,
    );
  }


  Future<void> _stateListener() async {
    final current = controller!.state.value;
    final old = lastState ?? const FeatureOverlayTourState();
    if (current.show && !old.show && entry == null) {
      // hide -> show
      entry = OverlayEntry(
        builder: (context) {
          return FOTOverlayView(controller: controller!);
        },
      );
      Overlay.of(context).insert(entry!);
    } else if (!current.show && entry != null) {
      entry?.remove();
      entry = null;
    }
    lastState = current;
  }
}