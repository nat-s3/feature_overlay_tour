import 'package:flutter/material.dart';

import 'fot_target_data.dart';

class FOTOverlayLayout extends StatelessWidget {
  const FOTOverlayLayout({
    super.key,
    this.padding = EdgeInsets.zero,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.linear,
    required this.child,
  });

  final EdgeInsets padding;
  final Duration duration;
  final Curve curve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final layoutModel = FOTTargetData.of(context).layoutModel;
    final universeRect = FOTTargetData.of(context).universeRect;
    final rawTargetRect = FOTTargetData.of(context).targetRect;
    final targetRect = padding.inflateRect(rawTargetRect);
    final modelResult = layoutModel.calculate(
      universe: universeRect,
      target: targetRect,
    );

    return Stack(
      children: [
        AnimatedPositioned(
          duration: duration,
          curve: curve,
          top: modelResult.area.top,
          left: modelResult.area.left,
          width: modelResult.area.width,
          height: modelResult.area.height,
          child: AnimatedAlign(
            alignment: modelResult.areaAlignment,
            duration: duration,
            child: child,
          ),
        ),
      ],
    );
  }
}
