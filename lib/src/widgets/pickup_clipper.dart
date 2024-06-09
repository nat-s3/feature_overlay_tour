import 'package:flutter/rendering.dart';

class PickupClipper extends ShapeBorderClipper {
  const PickupClipper({
    required super.shape,
    super.textDirection,
    required this.pickupRect,
    this.outer = true,
  });
  
  final Rect pickupRect;
  final bool outer;

  @override
  Path getClip(Size size) {
    final path = Path()
        ..addPath(
          shape.getOuterPath(pickupRect, textDirection: textDirection),
          Offset.zero,
        );

    if (outer) {
      path
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..fillType = PathFillType.evenOdd;
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper is PickupClipper && oldClipper.pickupRect != pickupRect || super.shouldReclip(oldClipper);
  }
}
