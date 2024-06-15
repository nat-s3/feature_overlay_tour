import 'dart:math';

import 'package:flutter/material.dart';

import '../model/line.dart';
import 'fot_target_data.dart';

class FeatureOverlayTourTooltipFrame extends StatelessWidget {
  const FeatureOverlayTourTooltipFrame({
    super.key,
    this.allowSize = const Size(32, 16),
    this.allowColor,
    this.padding = EdgeInsets.zero,
    this.allowSplit = 2,
    this.curve = Curves.decelerate,
    this.animatedDuration = const Duration(milliseconds: 500),
    required this.child,
  });
  final Size allowSize;
  final Color? allowColor;
  final EdgeInsets padding;
  final int allowSplit;
  final Curve curve;
  final Duration animatedDuration;
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

    //　オーバーレイ内の相対位置を計算する
    Alignment overlayAlign = modelResult.areaAlignment;

    /// ターゲットに一番近い位置に三角形を表示する
    // ターゲットと自身の表示領域の交点を求める
    final targetV = targetRect.center;
    final areaRect = Rect.fromLTRB(
      modelResult.area.left + allowSize.width/allowSplit,
        modelResult.area.top + allowSize.height/allowSplit,
        modelResult.area.right - allowSize.width/allowSplit,
        modelResult.area.bottom - allowSize.height/allowSplit,
    );
    final rectLines = [
      Line.fromOffset(areaRect.topLeft, areaRect.topRight),
      Line.fromOffset(areaRect.topRight, areaRect.bottomRight),
      Line.fromOffset(areaRect.bottomRight, areaRect.bottomLeft),
      Line.fromOffset(areaRect.bottomLeft, areaRect.topLeft),
    ];
    var pt = rectLines.map((l) => (l, l.perpendicularLineAtPoint(Point(targetV.dx, targetV.dy))))
        .map((e) => e.$2.getIntersection(e.$1))
        .whereType<Point<double>>()
        .map((e) => areaRect.wrapPoint(e))
        .fold(const Point(double.infinity, double.infinity), (p, v) {
      final center = Point(targetV.dx, targetV.dy);
      final p2 = center.distanceTo(v);
      final pp = center.distanceTo(p);
      return (pp > p2) ? v : p;
    });
    final trianglePoint = (pt.x == double.infinity) ? targetV : Offset(pt.x, pt.y);


    return Stack(
      children: [
        AnimatedPositioned(
          duration: animatedDuration,
          curve: curve,
          top: modelResult.area.top,
          left: modelResult.area.left,
          width: modelResult.area.width,
          height: modelResult.area.height,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: animatedDuration,
                curve: curve,
                // Centerに合わせる
                top: trianglePoint.dy - allowSize.height/2 - modelResult.area.top + (){
                  if (trianglePoint.dy < targetV.dy) {
                    return  -allowSize.height/2 + allowSize.height/allowSplit;
                  } else if (trianglePoint.dy == targetV.dy) {
                    return 0;

                  }
                  return allowSize.height/2 - allowSize.height/allowSplit;
                }(),
                left: trianglePoint.dx - allowSize.width/2 - modelResult.area.left + (){
                  if (trianglePoint.dy < targetV.dy) {
                    return 0;
                  } else if (trianglePoint.dy == targetV.dy) {
                    if (trianglePoint.dx < targetV.dx) {
                      return -allowSize.width/2 + allowSize.width/allowSplit;
                    } else {
                      return allowSize.width/2 - allowSize.width/allowSplit;
                    }
                  }
                  return 0;
                }(),
                child: SizedBox(
                  width: allowSize.width.toDouble(),
                  height: allowSize.height.toDouble(),
                  child: CustomPaint(
                    painter: TrianglePainter(
                      color: allowColor ?? Theme.of(context).colorScheme.surfaceContainer,
                      vertex: (){
                        if (trianglePoint.dy < targetV.dy) {
                          return TrianglePainterVertex.bottom;
                        } else if (trianglePoint.dy == targetV.dy) {
                          if (trianglePoint.dx < targetV.dx) {
                            return TrianglePainterVertex.right;
                          } else {
                            return TrianglePainterVertex.left;
                          }
                        }
                        return TrianglePainterVertex.top;
                      }(),
                    ),
                  ),
                ),
              ),
              AnimatedAlign(
                duration: animatedDuration,
                curve: curve,
                alignment: overlayAlign,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: trianglePoint.dy > targetV.dy ? allowSize.height/allowSplit : 0,
                    bottom: trianglePoint.dy < targetV.dy ? allowSize.height/allowSplit : 0,
                    left: trianglePoint.dy == targetV.dy && trianglePoint.dx > targetV.dx ? allowSize.width/allowSplit : 0,
                    right: trianglePoint.dy == targetV.dy && trianglePoint.dx < targetV.dx ? allowSize.width/allowSplit : 0,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class LinerPainter extends CustomPainter {
  const LinerPainter({
    required this.p1,
    required this.p2,
  });
  final Offset p1;
  final Offset p2;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(p1, p2, Paint()..strokeWidth = 2
      ..color = const Color(0xFFFF0000),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}

enum TrianglePainterVertex {
  top,
  right,
  bottom,
  left,
}

class TrianglePainter extends CustomPainter {
  const TrianglePainter({
    this.vertex = TrianglePainterVertex.top,
    required this.color,
  });

  final TrianglePainterVertex vertex;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 0
      ..color = color;

    /// 三角形を描画する
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, 0)
      ..close();

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(90 * vertex.index / 180 * pi);
    canvas.translate(-size.width / 2, -size.height / 2);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


