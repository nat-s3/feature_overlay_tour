import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class OverlayLayoutState {
  const OverlayLayoutState({
    required this.area,
    required this.areaType,
    required this.areaAlignment,
  });

  /// View Area
  final Rect area;

  /// View Area Type
  final OverlayLayoutType areaType;

  final Alignment areaAlignment;


  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is OverlayLayoutState &&
    area == other.area && areaType == other.areaType && areaAlignment == other.areaAlignment;
  }

  @override
  int get hashCode => Object.hash(area, areaType, areaAlignment);

}

/// 表示領域を示す
enum OverlayLayoutType {
  /// ```txt
  /// |xx |
  /// | C |
  /// |   |
  /// ```
  tl,
  /// ```txt
  /// |xxx|
  /// | C |
  /// |   |
  /// ```
  t,
  /// ```txt
  /// | xx|
  /// | C |
  /// |   |
  /// ```
  tr,
  /// ```txt
  /// |  x|
  /// | Cx|
  /// |   |
  /// ```
  rt,
  /// ```txt
  /// |  x|
  /// | Cx|
  /// |  x|
  /// ```
  r,
  /// ```txt
  /// |   |
  /// | Cx|
  /// |  x|
  /// ```
  rb,
  /// ```txt
  /// |   |
  /// | C |
  /// | xx|
  /// ```
  br,
  /// ```txt
  /// |   |
  /// | C |
  /// |xxx|
  /// ```
  b,
  /// ```txt
  /// |   |
  /// | C |
  /// |xx |
  /// ```
  bl,
  /// ```txt
  /// |   |
  /// |xC |
  /// |x  |
  /// ```
  lb,
  /// ```txt
  /// |x  |
  /// |xC |
  /// |x  |
  /// ```
  l,
  /// ```txt
  /// |x  |
  /// |xC |
  /// |   |
  /// ```
  lt,
}

/// オーバーレイ領域でのレイアウト配置をセル単位で決定するモデル
abstract interface class OverlayLayoutModel {
  OverlayLayoutState calculate({
    required Rect universe,
    required Rect target,
  });
}

/// オーバーレイ領域でのレイアウト配置を決めるモデル
///
/// ターゲットを基準とした3セル分の上下で大きいサイズを選択する
final class VerticalOverlayLayoutModel implements OverlayLayoutModel {
  const VerticalOverlayLayoutModel();
  @override
  OverlayLayoutState calculate({
    required Rect universe,
    required Rect target,
  }) {
    // 表示可能な領域を計算する
    final child = universe.intersect(target);
    final topSpace = child.top - universe.top;
    final bottomSpace = universe.bottom - child.bottom;

    // B|<--B-->[BOX]<--T-->|T
    if (bottomSpace <= topSpace) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, universe.top, universe.right, child.top),
        areaType: OverlayLayoutType.t,
        areaAlignment: Alignment.bottomCenter,
      );
    } else {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, child.bottom, universe.right, universe.bottom),
        areaType: OverlayLayoutType.b,
        areaAlignment: Alignment.topCenter,
      );
    }
  }
}

/// オーバーレイ領域でのレイアウト配置を決めるモデル
///
/// ターゲットを基準とした3セル分の左右で大きいサイズを選択する
final class HorizontalOverlayLayoutModel implements OverlayLayoutModel {
  const HorizontalOverlayLayoutModel();
  @override
  OverlayLayoutState calculate({
    required Rect universe,
    required Rect target,
  }) {
    // 表示可能な領域を計算する
    final child = universe.intersect(target);
    final leftSpace = child.left - universe.left;
    final rightSpace = universe.right - child.right;

    // L|<--L-->[BOX]<--R-->|R
    if (leftSpace <= rightSpace) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(child.right, universe.top, universe.right, universe.bottom),
        areaType: OverlayLayoutType.r,
        areaAlignment: Alignment.centerLeft,
      );
    } else {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, universe.top, child.left, universe.bottom),
        areaType: OverlayLayoutType.l,
        areaAlignment: Alignment.centerRight,
      );
    }
  }
}

/// オーバーレイ領域でのレイアウト配置を決めるモデル
///
/// ターゲットを基準とした3セル分の上下左右で大きいサイズを選択する
final class SquareOverlayLayoutModel implements OverlayLayoutModel {
  const SquareOverlayLayoutModel();
  @override
  OverlayLayoutState calculate({
    required Rect universe,
    required Rect target,
  }) {
    // 表示可能な領域を計算する
    final child = universe.intersect(target);

    // 空白領域を計算
    final topSpace = child.top - universe.top;
    final bottomSpace = universe.bottom - child.bottom;
    final leftSpace = child.left - universe.left;
    final rightSpace = universe.right - child.right;

    // Square(L/T/R/B)
    final tSQ = topSpace * universe.width;
    final bSQ = bottomSpace * universe.width;
    final lSQ = universe.height * leftSpace;
    final rSQ = universe.height * rightSpace;
    final maxi = [tSQ, rSQ, bSQ, lSQ].fold(0.0, (p, v) => max(p, v));

    if (tSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, universe.top, universe.right, child.top),
        areaType: OverlayLayoutType.t,
        areaAlignment: Alignment.bottomCenter,
      );
    } else if (bSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, child.bottom, universe.right, universe.bottom),
        areaType: OverlayLayoutType.b,
        areaAlignment: Alignment.topCenter,
      );
    } else if (lSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, universe.top, child.left, universe.bottom),
        areaType: OverlayLayoutType.l,
        areaAlignment: Alignment.centerRight,
      );
    } else /* (rSQ == maxi) */ {
      return OverlayLayoutState(
        area: Rect.fromLTRB(child.right, universe.top, universe.right, universe.bottom),
        areaType: OverlayLayoutType.r,
        areaAlignment: Alignment.centerLeft,
      );
    }
  }
}


/// オーバーレイ領域でのレイアウト配置を決めるモデル
///
/// ターゲットを基準とした隣接2セルで大きいサイズを選択する
final class TwoCellSquareOverlayLayoutModel implements OverlayLayoutModel {
  const TwoCellSquareOverlayLayoutModel();
  @override
  OverlayLayoutState calculate({
    required Rect universe,
    required Rect target,
  }) {
    // 表示可能な領域を計算する
    final child = universe.intersect(target);
    // 空白領域を計算
    final topSpace = child.top - universe.top;
    final bottomSpace = universe.bottom - child.bottom;
    final leftSpace = child.left - universe.left;
    final rightSpace = universe.right - child.right;
    // Square(TL/TR/RT/RB/BR/BL/LB/LT)
    final tlSQ = topSpace * (child.right - universe.left);
    final trSQ = topSpace * (universe.right - child.left);
    final rtSQ = (child.bottom - universe.top) * rightSpace;
    final rbSQ = (universe.bottom - child.top) * rightSpace;
    final brSQ = bottomSpace * (universe.right - child.left);
    final blSQ = bottomSpace * (child.right - universe.left);
    final lbSQ = (universe.bottom - child.top) * leftSpace;
    final ltSQ = (child.bottom - universe.top) * leftSpace;
    final maxi = [tlSQ, trSQ, rtSQ, rbSQ, brSQ, blSQ, lbSQ,ltSQ].fold(0.0, (p, v) => max(p, v));

    if (tlSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, universe.top, child.right, child.top),
        areaType: OverlayLayoutType.tl,
        areaAlignment: Alignment.bottomRight,
      );
    } else if (trSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(child.left, universe.top, universe.right, child.top),
        areaType: OverlayLayoutType.tr,
        areaAlignment: Alignment.bottomLeft,
      );
    } else if (rtSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(child.right, universe.top, universe.right, child.bottom),
        areaType: OverlayLayoutType.rt,
        areaAlignment: Alignment.bottomLeft,
      );
    } else if (rbSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(child.right, child.top, universe.right, universe.bottom),
        areaType: OverlayLayoutType.rb,
        areaAlignment: Alignment.topLeft,
      );
    } else if (brSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(child.left, child.bottom, universe.right, universe.bottom),
        areaType: OverlayLayoutType.br,
        areaAlignment: Alignment.topLeft,
      );
    } else if (blSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, child.bottom, child.right, universe.bottom),
        areaType: OverlayLayoutType.bl,
        areaAlignment: Alignment.topRight,
      );
    } else if (lbSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, child.top, child.left, universe.bottom),
        areaType: OverlayLayoutType.lb,
        areaAlignment: Alignment.topRight,
      );
    } else /* (ltSQ == maxi) */ {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, universe.top, child.left, child.bottom),
        areaType: OverlayLayoutType.lt,
        areaAlignment: Alignment.bottomRight,
      );
    }
  }
}


/// オーバーレイ領域でのレイアウト配置を決めるモデル
///
/// ターゲットを基準とした2セル分の上下で大きいサイズを選択する
final class TwoCellVerticalOverlayLayoutModel implements OverlayLayoutModel {
  const TwoCellVerticalOverlayLayoutModel();
  @override
  OverlayLayoutState calculate({
    required Rect universe,
    required Rect target,
  }) {
    // 表示可能な領域を計算する
    final child = universe.intersect(target);
    // 空白領域を計算
    final topSpace = child.top - universe.top;
    final bottomSpace = universe.bottom - child.bottom;
    // Square(TL/TR/RT/RB/BR/BL/LB/LT)
    final tlSQ = topSpace * (child.right - universe.left);
    final trSQ = topSpace * (universe.right - child.left);
    final brSQ = bottomSpace * (universe.right - child.left);
    final blSQ = bottomSpace * (child.right - universe.left);
    final maxi = [tlSQ, trSQ, brSQ, blSQ].fold(0.0, (p, v) => max(p, v));

    if (tlSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, universe.top, child.right, child.top),
        areaType: OverlayLayoutType.tl,
        areaAlignment: Alignment.bottomRight,
      );
    } else if (trSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(child.left, universe.top, universe.right, child.top),
        areaType: OverlayLayoutType.tr,
        areaAlignment: Alignment.bottomLeft,
      );
    } else if (brSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(child.left, child.bottom, universe.right, universe.bottom),
        areaType: OverlayLayoutType.br,
        areaAlignment: Alignment.topLeft,
      );
    } else /* (blSQ == maxi) */ {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, child.bottom, child.right, universe.bottom),
        areaType: OverlayLayoutType.bl,
        areaAlignment: Alignment.topRight,
      );
    }
  }
}


/// オーバーレイ領域でのレイアウト配置を決めるモデル
///
/// ターゲットを基準とした2セル分の左右で大きいサイズを選択する
final class TwoCellHorizontalOverlayLayoutModel implements OverlayLayoutModel {
  const TwoCellHorizontalOverlayLayoutModel();
  @override
  OverlayLayoutState calculate({
    required Rect universe,
    required Rect target,
  }) {
    // 表示可能な領域を計算する
    final child = universe.intersect(target);
    // 空白領域を計算
    final leftSpace = child.left - universe.left;
    final rightSpace = universe.right - child.right;
    // Square(TL/TR/RT/RB/BR/BL/LB/LT)
    final rtSQ = (child.bottom - universe.top) * rightSpace;
    final rbSQ = (universe.bottom - child.top) * rightSpace;
    final lbSQ = (universe.bottom - child.top) * leftSpace;
    final ltSQ = (child.bottom - universe.top) * leftSpace;
    final maxi = [rtSQ, rbSQ, lbSQ,ltSQ].fold(0.0, (p, v) => max(p, v));

    if (rtSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(child.right, universe.top, universe.right, child.bottom),
        areaType: OverlayLayoutType.rt,
        areaAlignment: Alignment.bottomLeft,
      );
    } else if (rbSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(child.right, child.top, universe.right, universe.bottom),
        areaType: OverlayLayoutType.rb,
        areaAlignment: Alignment.topLeft,
      );
    } else if (lbSQ == maxi) {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, child.top, child.left, universe.bottom),
        areaType: OverlayLayoutType.lb,
        areaAlignment: Alignment.topRight,
      );
    } else /* (ltSQ == maxi) */ {
      return OverlayLayoutState(
        area: Rect.fromLTRB(universe.left, universe.top, child.left, child.bottom),
        areaType: OverlayLayoutType.lt,
        areaAlignment: Alignment.bottomRight,
      );
    }
  }
}
