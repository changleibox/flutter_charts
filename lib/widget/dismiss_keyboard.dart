import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Created by box on 3/14/21.
///
/// 点击空白处，键盘消失
class DismissKeyboard extends StatefulWidget {
  /// 构造函数
  const DismissKeyboard({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  /// child
  final Widget child;

  @override
  _DismissKeyboardState createState() => _DismissKeyboardState();
}

class _DismissKeyboardState extends State<DismissKeyboard> {
  @override
  void initState() {
    GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
    super.initState();
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_handlePointerEvent);
    super.dispose();
  }

  void _handlePointerEvent(PointerEvent event) {
    if (primaryFocus?.hasFocus != true || (event is! PointerUpEvent && event is! PointerCancelEvent)) {
      return;
    }
    final result = HitTestResult();
    WidgetsBinding.instance.hitTest(result, event.position);
    if (result.path.map((e) => e.target).any((element) => element is RenderEditable)) {
      return;
    }
    primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
