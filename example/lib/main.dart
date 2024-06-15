import 'dart:math';

import 'package:feature_overlay_tour/feature_overlay_tour.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const containerSize = Size(200, 200);
    return MaterialApp(
      home: FeatureOverlayTour(
        child: Scaffold(
          body: SafeArea(
            minimum: const EdgeInsets.all(50),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Builder(
                    builder: (context) {
                      return FeatureOverlayTourTarget(
                        key: GlobalKey(),
                        shape: const StadiumBorder(),
                        order: 0,
                        overlayPadding: const EdgeInsets.all(10),
                        onItemTap: FOTScope.once(context).controller.next,
                        overlay: FOTOverlayLayout(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            width: containerSize.width,
                            height: containerSize.height,
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FilledButton(
                                  onPressed: () {
                                    FOTScope.once(context).controller.next();
                                  },
                                  child: const Text('next'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // overlay: FeatureOverlayTourTooltipFrame(
                        //   child: Container(
                        //     width: containerSize.width,
                        //     height: containerSize.height,
                        //     color: Theme.of(context).colorScheme.surfaceContainer,
                        //     child: Column(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         FilledButton(
                        //           onPressed: () {
                        //             FOTScope.once(context).controller.next();
                        //           },
                        //           child: const Text('next'),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        child: ElevatedButton(
                          onPressed: () {
                            FOTScope.once(context).controller.launch();
                          },
                          child: const Text('Overlay'),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Builder(
                    builder: (context) {
                      return FeatureOverlayTourTarget(
                        key: GlobalKey(),
                        overlayPadding: const EdgeInsets.all(20),
                        order: 1,
                        onItemTap: FOTScope.once(context).controller.next,
                        overlay: FeatureOverlayTourTooltipFrame(
                          child: Container(
                            width: containerSize.width,
                            height: containerSize.height,
                            color: Colors.white.withOpacity(0.5),
                            child: const Text('Container2'),
                          ),
                        ),
                        child: const Text('Target'),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Builder(
                    builder: (context) {
                      return FeatureOverlayTourTarget(
                        key: GlobalKey(),

                        overlayPadding: const EdgeInsets.all(20),
                        order: 2,
                        onItemTap: FOTScope.once(context).controller.next,
                        overlay: FeatureOverlayTourTooltipFrame(
                          child: Container(
                            width: containerSize.width,
                            height: containerSize.height,
                            color: Colors.white.withOpacity(0.5),
                            child: const Text('Container2'),
                          ),
                        ),
                        child: const Text('Target'),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Builder(
                      builder: (context) {
                        return FeatureOverlayTourTarget(
                          key: GlobalKey(),
                          overlayPadding: const EdgeInsets.all(20),
                          order: 3,
                          onItemTap: FOTScope.once(context).controller.next,
                          overlay: FeatureOverlayTourTooltipFrame(
                            child: Container(
                              width: containerSize.width,
                              height: containerSize.height,
                              color: Colors.white.withOpacity(0.5),
                              child: const Text('Container2'),
                            ),
                          ),
                          child: const Text('Target'),
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Builder(
                    builder: (context) {
                      return FeatureOverlayTourTarget(
                        key: GlobalKey(),

                        overlayPadding: const EdgeInsets.all(20),
                        order: 4,
                        onItemTap: FOTScope.once(context).controller.next,
                        overlay: FeatureOverlayTourTooltipFrame(
                          child: Container(
                            width: containerSize.width,
                            height: containerSize.height,
                            color: Colors.white.withOpacity(0.5),
                            child: const Text('Container2'),
                          ),
                        ),
                        child: const Text('Target'),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Builder(
                    builder: (context) {
                      return FeatureOverlayTourTarget(
                        key: GlobalKey(),

                        overlayPadding: const EdgeInsets.all(20),
                        order: 5,
                        onItemTap: FOTScope.once(context).controller.next,
                        overlay: FeatureOverlayTourTooltipFrame(
                          child: Container(
                            width: containerSize.width,
                            height: containerSize.height,
                            color: Colors.white.withOpacity(0.5),
                            child: const Text('Container2'),
                          ),
                        ),
                        child: const Text('Target'),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Builder(
                    builder: (context) {
                      return FeatureOverlayTourTarget(
                        key: GlobalKey(),

                        overlayPadding: const EdgeInsets.all(20),
                        order: 6,
                        onItemTap: FOTScope.once(context).controller.next,
                        overlay: FeatureOverlayTourTooltipFrame(
                          child: Container(
                            width: containerSize.width,
                            height: containerSize.height,
                            color: Colors.white.withOpacity(0.5),
                            child: const Text('Container2'),
                          ),
                        ),
                        child: const Text('Target'),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Builder(
                    builder: (context) {
                      return FeatureOverlayTourTarget(
                        key: GlobalKey(),

                        overlayPadding: const EdgeInsets.all(20),
                        order: 7,
                        onItemTap: FOTScope.once(context).controller.next,
                        overlay: FeatureOverlayTourTooltipFrame(
                          child: Container(
                            width: containerSize.width,
                            height: containerSize.height,
                            color: Colors.white.withOpacity(0.5),
                            child: const Text('Container2'),
                          ),
                        ),
                        child: const Text('Target'),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Builder(
                    builder: (context) {
                      return FeatureOverlayTourTarget(
                        key: GlobalKey(),

                        overlayPadding: const EdgeInsets.all(20),
                        order: 8,
                        onItemTap: FOTScope.once(context).controller.next,
                        overlay: FeatureOverlayTourTooltipFrame(
                          child: Container(
                            width: containerSize.width,
                            height: containerSize.height,
                            color: Colors.white.withOpacity(0.5),
                            child: const Text('Container2'),
                          ),
                        ),
                        child: const Text('Target'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class OverlaySample2 extends StatelessWidget {
  const OverlaySample2({super.key});

  @override
  Widget build(BuildContext context) {
    final xNotify = ValueNotifier(200);
    final yNotify = ValueNotifier(200);

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                height: 400,
                child: ValueListenableBuilder(
                  valueListenable: xNotify,
                  builder: (context, xValue, child) {
                    return ValueListenableBuilder(
                      valueListenable: yNotify,
                      builder: (context, yValue, child) {
                        // 計算コード
                        const OverlayLayoutModel model = TwoCellSquareOverlayLayoutModel();
                        // const OverlayLayoutModel model = SquareOverlayLayoutModel();
                        final targetRect = Rect.fromCenter(
                          center: Offset(xValue.toDouble(), yValue.toDouble()),
                          width: 100,
                          height: 100,
                        );
                        final modelResult = model.calculate(
                          universe: Rect.fromPoints(Offset.zero, const Offset(400, 400)),
                          target: targetRect,
                        );
                        //　オーバーレイ内の相対位置を計算する
                        Alignment overlayAlign = modelResult.areaAlignment;

                        /// ターゲットに一番近い位置に三角形を表示する
                        // ターゲットと自身の表示領域の交点を求める
                        const allowSize = 20;
                        final targetV = targetRect.center;
                        final areaRect = modelResult.area.deflate(allowSize/2);
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

                        final views = rectLines.map((l) => (l, l.perpendicularLineAtPoint(Point(targetV.dx, targetV.dy))))
                            .map((e) => e.$2.getIntersection(e.$1))
                            .whereType<Point<double>>()
                            .map((e) => areaRect.wrapPoint(e))
                            .map((p) {
                          return Positioned(
                            left: p.x - 2,
                            top: p.y - 2,
                            child: const SizedBox(
                              width: 4,
                              height: 4,
                              child: ColoredBox(
                                color: Colors.red,
                                child: Center(),
                              ),
                            ),
                          );
                        }).toList();

                        const duration = Duration(milliseconds: 500);
                        const curve = Curves.decelerate;


                        return Stack(
                          children: [
                            ColoredBox(
                              color: Colors.green.withOpacity(0.1),
                              child: const Center(),
                            ),
                            Positioned(
                              left: targetRect.left,
                              top: targetRect.top,
                              width: targetRect.width,
                              height: targetRect.height,
                              child: ColoredBox(
                                color: Colors.red.withOpacity(0.5),
                              ),
                            ),
                            AnimatedPositioned(
                              duration: duration,
                              curve: curve,
                              top: modelResult.area.top,
                              left: modelResult.area.left,
                              width: modelResult.area.width,
                              height: modelResult.area.height,
                              child: ColoredBox(
                                color: Colors.lightBlue.withOpacity(0.5),
                                child: Stack(
                                  children: [
                                    AnimatedAlign(
                                      duration: duration,
                                      curve: curve,
                                      alignment: overlayAlign,
                                      child: const SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: ColoredBox(
                                          color: Colors.yellow,
                                          child: Center(),
                                        ),
                                      ),
                                    ),
                                    AnimatedAlign(
                                      duration: duration,
                                      curve: curve,
                                      alignment: overlayAlign,
                                      child: Padding(
                                        padding: const EdgeInsets.all(allowSize/2),
                                        child: SizedBox(
                                          width: 100 - allowSize.toDouble(),
                                          height: 100 - allowSize.toDouble(),
                                          child: const ColoredBox(
                                            color: Colors.deepOrange,
                                            child: Center(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    AnimatedPositioned(
                                      duration: duration,
                                      curve: curve,
                                      // Centerに合わせる
                                      top: trianglePoint.dy - allowSize/2 - modelResult.area.top,
                                      left: trianglePoint.dx - allowSize/2 - modelResult.area.left,
                                      child: SizedBox(
                                        width: allowSize.toDouble(),
                                        height: allowSize.toDouble(),
                                        child: CustomPaint(
                                          painter: TrianglePainter(
                                            color: Colors.purple,
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
                                  ],
                                ),
                              ),
                            ),
                            // ...views,
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Text('X : '),
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: xNotify,
                              builder: (context, value, child) {
                                return Slider(
                                  value: value.toDouble(),
                                  min: 0,
                                  max: 400,
                                  onChanged: (v) {
                                    xNotify.value = v.toInt();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Y : '),
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: yNotify,
                              builder: (context, value, child) {
                                return Slider(
                                  value: value.toDouble(),
                                  min: 0,
                                  max: 400,
                                  onChanged: (v) {
                                    yNotify.value = v.toInt();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

