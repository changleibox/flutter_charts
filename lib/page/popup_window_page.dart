import 'package:flatterer/flatterer.dart';
import 'package:flutter/material.dart';

/// Created by box on 3/13/21.
/// 
/// PopupWindow demo
class PopupWindowPage extends StatefulWidget {
  @override
  _PopupWindowPageState createState() => _PopupWindowPageState();
}

class _PopupWindowPageState extends State<PopupWindowPage> {
  final _anchorWindowKey = GlobalKey<OverlayWindowAnchorState>();
  final _containerWindowKey = GlobalKey<StackWindowContainerState>();
  final _buttonKey = GlobalKey();
  final _link = LayerLink();

  int _counter = 0;

  void _incrementCounter() {
    _showWindow();
    setState(() {
      _counter++;
    });
  }

  void _showWindow() {
    _anchorWindowKey.currentState?.show();
    final renderBox = _buttonKey.currentContext?.findRenderObject() as RenderBox;
    if (renderBox?.hasSize != true) {
      return;
    }
    _containerWindowKey.currentState?.show(renderBox.localToGlobal(Offset.zero) & renderBox.size);
  }

  Widget _buildWindow(BuildContext context) {
    return TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('data')));
      },
      child: Container(
        width: 100,
        height: 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StackWindowContainer(
      key: _containerWindowKey,
      link: _link,
      margin: 10,
      direction: Axis.horizontal,
      builder: _buildWindow,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo Home Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const TextField(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartDocked,
        floatingActionButton: OverlayWindowAnchor(
          key: _anchorWindowKey,
          margin: 10,
          builder: _buildWindow,
          child: CompositedTransformTarget(
            link: _link,
            child: FloatingActionButton(
              key: _buttonKey,
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
