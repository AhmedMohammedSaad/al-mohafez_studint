import 'package:flutter/material.dart';

class KeyboardDismissObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _dismissKeyboard();
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _dismissKeyboard();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _dismissKeyboard();
    super.didPop(route, previousRoute);
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    _dismissKeyboard();
    super.didStartUserGesture(route, previousRoute);
  }

  void _dismissKeyboard() {
    final focusNode = FocusManager.instance.primaryFocus;
    if (focusNode?.hasFocus ?? false) {
      focusNode?.unfocus();
    }
  }
}

// app_focus_handler.dart
class AppFocusHandler extends StatelessWidget {
  const AppFocusHandler({
    super.key,
    required this.child,
  });
  final Widget child;

  bool _isTapOnExcludedWidgets(BuildContext context, Offset globalPosition) {
    final transportBox = _findRenderObjectByKey(
      context,
      const Key('transportButton'),
    );

    final deliveryBox = _findRenderObjectByKey(
      context,
      const Key('deliveryButton'),
    );

    if (transportBox != null && _isPointInsideBox(transportBox, globalPosition)) {
      return true;
    }

    if (deliveryBox != null && _isPointInsideBox(deliveryBox, globalPosition)) {
      return true;
    }

    return false;
  }

  RenderBox? _findRenderObjectByKey(BuildContext context, Key key) {
    final element = context.findAncestorRenderObjectOfType<RenderBox>();
    return element;
  }

  bool _isPointInsideBox(RenderBox box, Offset globalPosition) {
    final localPosition = box.globalToLocal(globalPosition);
    return localPosition.dx >= 0 &&
        localPosition.dx <= box.size.width &&
        localPosition.dy >= 0 &&
        localPosition.dy <= box.size.height;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onTapDown: (TapDownDetails details) {
        if (_isTapOnExcludedWidgets(context, details.globalPosition)) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
