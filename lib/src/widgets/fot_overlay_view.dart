import 'dart:math';

import 'package:feature_overlay_tour/src/model/overlay_layout_model.dart';
import 'package:feature_overlay_tour/src/widgets/pickup_clipper.dart';
import 'package:flutter/material.dart';

import '../controllers/fot_controller.dart';
import 'feature_overlay_tour_target.dart';
import 'fot_target_data.dart';

class FOTOverlayView extends StatefulWidget {
  const FOTOverlayView({
    super.key,
    required this.controller,
  });

  final FOTController controller;

  @override
  State<FOTOverlayView> createState() => _FOTOverlayViewState();
}

class _FOTOverlayViewState extends State<FOTOverlayView> with SingleTickerProviderStateMixin {

  late AnimationController animationController;
  late CurveTween curveTween;
  late Animation<double> backgroundAnimation;
  late Animation<double> overlayAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: widget.controller.duration,
    );
    // bind controller
    widget.controller.animationController = animationController;

    curveTween = CurveTween(curve: Curves.linear);
    backgroundAnimation = CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.fastLinearToSlowEaseIn),
    ).drive(curveTween);
    overlayAnimation = CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.8, 1.0, curve: Curves.fastLinearToSlowEaseIn),
    );

    super.initState();
  }

  @override
  void dispose() {
    widget.controller.animationController = null;
    animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller.state,
      builder: (context, value, child) {
        final gKey = widget.controller.readKey(value.current);
        if (gKey == null) {
          return const Text('Error: Unset GlobalKey');
        }
        final deviceSize = MediaQuery.sizeOf(context);
        final systemPadding = MediaQuery.paddingOf(context);
        final targetBox = gKey.currentContext?.findRenderObject() as RenderBox?;
        final targetPos = targetBox?.localToGlobal(Offset.zero);
        final targetRect = targetBox?.paintBounds;
        final rawTargetWidgetRect = targetPos! & targetRect!.size;

        // TargetWidget
        final targetWidget = gKey.currentWidget as FeatureOverlayTourTarget?;
        final overlay = targetWidget?.overlay;
        final shape = targetWidget?.shape ?? const RoundedRectangleBorder();
        final backgroundColor = targetWidget?.backgroundColor ?? const Color(0xAA000000);
        final padding = targetWidget?.overlayPadding;
        final maxDistance = max(deviceSize.width, deviceSize.height);
        final distance = Offset(maxDistance, maxDistance).distance * (targetWidget?.overlayDistanceRatio ?? 2.0);
        final targetWidgetRect = (padding ?? EdgeInsets.zero).inflateRect(rawTargetWidgetRect);
        final onTap = targetWidget?.onItemTap;
        final layoutModel = targetWidget?.layoutModel ?? const VerticalOverlayLayoutModel();

        // OverlayWidget
        // 表示可能な領域を計算
        final universe = systemPadding.deflateRect(
          Rect.fromLTWH(0, 0, deviceSize.width, deviceSize.height),
        );



        return Material(
          color: const Color(0x00000000),
          child: Stack(
            children: [
              // Overlay Gesture Barrier
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {},
                ),
              ),
              // Background ModalBarrier
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    switch (widget.controller.dismissMode) {
                      case DismissMode.none:
                        break;
                      case DismissMode.next:
                        widget.controller.next();
                        break;
                      case DismissMode.close:
                        widget.controller.close();
                        break;
                    }
                  },
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      // 領域アニメーション
                      final v = backgroundAnimation.value;
                      final rect = Rect.fromCenter(
                        center: targetWidgetRect.center,
                        width: targetWidgetRect.width + distance * (1.0 - v),
                        height: targetWidgetRect.height + distance * (1.0 - v),
                      );

                      return ClipPath(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        clipper: PickupClipper(
                          shape: shape,
                          pickupRect: rect,
                        ),
                        child: child,
                      );
                    },
                    child: ColoredBox(
                      color: backgroundColor,
                    ),
                  ),
                ),
              ),
              // Item Click
              Positioned.fromRect(
                rect: targetWidgetRect,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: overlayAnimation.value,
                      child: child!,
                    );
                  },
                  child: InkWell(
                    customBorder: shape,
                    onTap: onTap,
                    child: const ColoredBox(
                      color: Color(0x00000000),
                    ),
                  ),
                ),
              ),
              // Overlay Widget
              Positioned.fill(
                child: FOTTargetData(
                  targetRect: targetWidgetRect,
                  layoutModel: layoutModel,
                  universeRect: universe,
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: overlayAnimation.value,
                        child: child!,
                      );
                    },
                    child: overlay,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


class DebugPoint extends StatelessWidget {
  const DebugPoint({
    super.key,
    required this.rect,
    required this.child,
  });

  final Rect rect;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: ColoredBox(
            color: Colors.green.withOpacity(0.3),
            child: const SizedBox.expand(),
          ),
        ),
        child,
        Center(
            child: Tooltip(
              message: '$rect',
              child: const ColoredBox(
                color: Colors.red,
                child: SizedBox(
                  width: 25,
                  height: 25,
                ),
              ),
            )
        )
      ],
    );
  }
}
