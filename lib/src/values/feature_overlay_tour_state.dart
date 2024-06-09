import 'package:flutter/widgets.dart';

@immutable
class FeatureOverlayTourState {
  const FeatureOverlayTourState({
    this.show = false,
    this.animate = false,
    this.current,
  });

  final bool show;

  final bool animate;
  final int? current;

  FeatureOverlayTourState copyWith({
    bool? show,
    bool? animate,
    int? current,
    bool inherit = true,
  }) {
    return FeatureOverlayTourState(
      show: show ?? this.show,
      animate: animate ?? this.animate,
      current: current ?? (inherit ? this.current : null),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is FeatureOverlayTourState && other.show == show && other.current == current && other.animate == animate;
  }

  @override
  int get hashCode => Object.hash(show, current, animate);
}