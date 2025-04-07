import 'package:flutter/material.dart';

enum PaginationState { loaded, paginating }

///triggers a callback when reaching the scrollable widget bottom.
///
extension BottomTrigger on ScrollController {
  ///Triggers [onTrigger] when scrollable widget reaches the [limitFraction] point
  ///
  ///which is the fraction of the screen at which the [onTrigger] is called.
  ///
  ///[limitFraction] default to `0.9`.
  ///
  void onScroll(VoidCallback onTrigger, {double? limitFraction}) {
    addListener(() {
      if (!_isBottom(limitFraction ?? 0.75)) return;
      onTrigger.call();
    });
  }

  bool _isBottom(double limitFraction) {
    if (!hasClients) return false;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = offset;
    return currentScroll >= (maxScroll * limitFraction);
  }
}
