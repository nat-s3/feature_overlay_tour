import 'dart:math';

import 'package:feature_overlay_tour/feature_overlay_tour.dart';
import 'package:feature_overlay_tour/src/widgets/pickup_clipper.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FeatureOverlayTourOverlay extends StatefulWidget {
  const FeatureOverlayTourOverlay({
    super.key,
    required this.controller,
  });

  final FeatureOverlayTourController controller;

  @override
  State<FeatureOverlayTourOverlay> createState() => _FeatureOverlayTourOverlayState();
}

class _FeatureOverlayTourOverlayState extends State<FeatureOverlayTourOverlay> with SingleTickerProviderStateMixin {

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
          return const Text('Error');
        }
        final deviceSize = MediaQuery.sizeOf(context);
        final systemPadding = MediaQuery.paddingOf(context);
        final targetBox = gKey.currentContext?.findRenderObject() as RenderBox?;
        final targetPos = targetBox?.localToGlobal(Offset.zero);
        final targetRect = targetBox?.paintBounds;
        final rawTargetWidgetRect = targetPos! & targetRect!.size;
        // WidgetsBinding.instance.addPostFrameCallback((d) {
        //   animatedOpacity.value = 1.0;
        // });

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

        // OverlayWidget
        // 表示可能な領域を計算
        final overlayRect = systemPadding.deflateRect(
          Rect.fromLTWH(0, 0, deviceSize.width, deviceSize.height),
        );
        // TargetWidgetと重ならない縦の領域を取得
        final pTopSpace = targetWidgetRect.top - overlayRect.top;
        final pBottomSpace = (overlayRect.top + overlayRect.height) - (targetWidgetRect.top + targetWidgetRect.height);

        // TargetWidgetと重ならない横の領域を取得
        final pLeftSpace = targetWidgetRect.left - overlayRect.left;
        final pRightSpace = (overlayRect.left + overlayRect.width) - (targetWidgetRect.left + targetWidgetRect.width);
        final boxConstraint = BoxConstraints(
            maxWidth: overlayRect.width,
            maxHeight: pTopSpace <= pBottomSpace
                ? pBottomSpace
                : pTopSpace
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
              Positioned(
                // デフォルトの表示位置を調整する
                top: pTopSpace <= pBottomSpace
                    ? targetWidgetRect.bottom
                    : null,
                bottom: pTopSpace <= pBottomSpace
                    ? null
                    : overlayRect.bottom - targetWidgetRect.top,
                left: pLeftSpace <= pRightSpace
                    ? overlayRect.left
                    : null,
                right: pLeftSpace <= pRightSpace
                    ? null
                    : (overlayRect.left + overlayRect.width) - overlayRect.right,
                child: ConstrainedBox(
                  constraints: boxConstraint,
                  child: OverlayPositionData(
                    constraint: boxConstraint,
                    targetLocalCenter: Offset(
                      rawTargetWidgetRect.left - overlayRect.left + rawTargetWidgetRect.width / 2,
                      rawTargetWidgetRect.top - overlayRect.top + rawTargetWidgetRect.height / 2,
                    ),
                    overlayOffset: Offset(
                      pTopSpace <= pBottomSpace
                          ? targetWidgetRect.bottom + (pBottomSpace/2)
                          : overlayRect.bottom - targetWidgetRect.top + (pTopSpace/2),
                      overlayRect.width / 2,
                    ),
                    targetSize: rawTargetWidgetRect.size,
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
              ),
            ],
          ),
        );
      },
    );
  }
}
