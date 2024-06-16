
import 'dart:async';

import 'package:feature_overlay_tour/src/values/feature_overlay_tour_state.dart';
import 'package:flutter/widgets.dart';

enum DismissMode {
  none,
  next,
  close,
}

/// 制御を行うためのコントローラー
class FOTController {
  FOTController({
    this.duration = const Duration(seconds: 1),
    this.overlayDuration = const Duration(microseconds: 500),
    this.dismissMode = DismissMode.next,
  });

  AnimationController? animationController;

  final _keyMap = <int, WeakReference<GlobalKey>>{};

  final state = ValueNotifier(const FeatureOverlayTourState());

  final Duration duration;
  final Duration overlayDuration;

  final DismissMode dismissMode;


  /// Internal Access
  void registerKey({
    required int order,
    required GlobalKey key,
  }) {
    _keyMap[order] = WeakReference(key);
  }

  /// Internal Access
  void removeKey({
    required int order,
    required GlobalKey key,
  }) {
    if (key == _keyMap[order]?.target) {
      _keyMap.remove(order);
    }
  }

  /// Internal Access
  GlobalKey? readKey(int? order) {
    return _keyMap[order]?.target;
  }

  /// 表示を開始する
  Future<void> launch() async {
    final orders = _keyMap.keys.toList()..sort();
    int? next = orders.firstOrNull;
    state.value = state.value.copyWith(show: next != null, current: next);
    final aniCon = await _waitAniCon();
    final feature = aniCon.forward();
    final animeCompleter = Completer<bool>();
    feature.whenComplete(() => animeCompleter.complete(true));
    await animeCompleter.future;
  }

  Future<AnimationController> _waitAniCon() async {
    final completer = Completer<AnimationController>();
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (animationController != null) {
        timer.cancel();
        completer.complete(animationController!);
      }
    });
    return await completer.future;
  }
  Future<void> _waitTicker(TickerFuture tickerFuture) async {
    final completer = Completer<bool>();
    tickerFuture.whenComplete(() => completer.complete(true));
    await completer.future;
  }

  /// 表示を終了する
  Future<void> close() async {
    final aniCon = await _waitAniCon();
    await _waitTicker(aniCon.reverse());
    state.value = state.value.copyWith(show: false, current: null);
  }

  /// 次に移動する
  Future<void> next() async {
    int? next = nextIndex;

    final newValue = state.value.copyWith(current: next, show: next != null);
    final aniCon = await _waitAniCon();
    final feature = aniCon.reverse();
    if (newValue.current != null) {
      await Future.delayed(duration);
      aniCon.stop(canceled: true);
      state.value = newValue;
      await _waitTicker(aniCon.forward());
    } else {
      await Future.delayed(duration);
      await _waitTicker(feature);
      state.value = newValue;
    }
  }

  /// 1つ戻る
  Future<void> pref() async {
    int? next = prefIndex;

    state.value = state.value.copyWith(current: next, show: next != null);
  }

  int? get nextIndex {
    final current = state.value;

    final orders = _keyMap.keys.toList()..sort();
    int? next;
    for (final order in orders) {
      if (current.current == null) {
        next = order;
        break;
      } else if (current.current! < order) {
        next = order;
        break;
      }
    }

    return next;
  }


  int? get prefIndex {
    final current = state.value;

    final orders = (_keyMap.keys.toList()..sort()).reversed.toList();
    int? next;
    for (final order in orders) {
      if (current.current == null) {
        next = order;
        break;
      } else if (order < current.current!) {
        next = order;
        break;
      }
    }

    return next;
  }
}