import 'package:flutter/foundation.dart';

class SideSwipeController extends ChangeNotifier {
  VoidCallback? _onSwipeLeft;
  VoidCallback? _onSwipeRight;
  VoidCallback? _onUndo;

  void attach({
    VoidCallback? onSwipeLeft,
    VoidCallback? onSwipeRight,
    VoidCallback? onUndo,
  }) {
    _onSwipeLeft = onSwipeLeft;
    _onSwipeRight = onSwipeRight;
    _onUndo = onUndo;
  }

  void swipeLeft() {
    _onSwipeLeft?.call();
  }

  void swipeRight() {
    _onSwipeRight?.call();
  }

  void undo() {
    _onUndo?.call();
  }

  void detach() {
    _onSwipeLeft = null;
    _onSwipeRight = null;
    _onUndo = null;
  }

  @override
  void dispose() {
    detach();
    super.dispose();
  }
}
