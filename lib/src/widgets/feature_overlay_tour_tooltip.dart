import 'package:flutter/widgets.dart';

import 'overlay_position_data.dart';

class FeatureOverlayTourTooltip extends StatelessWidget {
  const FeatureOverlayTourTooltip({
    super.key,
    this.allowAlign,
    this.padding = EdgeInsets.zero,
    this.allowSize = 10,
    required this.child,
  });

  final Alignment? allowAlign;

  final double allowSize;

  final EdgeInsetsGeometry padding;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.sizeOf(context);
    final data = OverlayPositionData.of(context);
    var alignment = allowAlign ?? Alignment(
      _stepper(data.targetLocalCenter.dx, deviceSize.width),
      _stepper(data.targetLocalCenter.dy, deviceSize.height),
    );
    if (alignment == Alignment.center) {
      alignment = Alignment.topCenter;
    }

    final allowInnerSize = allowSize < 0.0 ? 0.0 : allowSize;

    return Padding(
      padding: padding,
      child: Stack(
        children: [
          Align(
            alignment: alignment,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: allowInnerSize,
              ),
              child: ColoredBox(
                color: const Color(0xFF00AAAF),
                child: child,
              ),
            ),
          ),
          if (0.0 < allowInnerSize)
            Align(
              alignment: alignment,
              child: SizedBox(
                width: allowInnerSize,
                height: allowInnerSize,
                child: const ColoredBox(
                  color: Color(0xFFFF0000),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _stepper(double target, double range) {
    final v = ((target/range - 0.5)*10).round();
    if (v < 0) {
      return -1;
    } else if (0 < v) {
      return 1;
    }
    return 0;
  }
}
