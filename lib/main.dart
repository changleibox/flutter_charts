import 'package:flutter/material.dart';
import 'package:flutter_charts/page/charts_bug_page.dart';
import 'package:flutter_charts/page/charts_page.dart';
import 'package:flutter_charts/page/custom_scroll_view_page.dart';
import 'package:flutter_charts/page/home_page.dart';
import 'package:flutter_charts/widget/dismiss_keyboard.dart';
import 'package:flutter_charts/page/popup_window_page.dart';

void main() {
  runApp(FlutterCharts());
}

/// App
class FlutterCharts extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        return DismissKeyboard(
          child: child,
        );
      },
      routes: <String, WidgetBuilder>{
        '/': (context) => HomePage(),
        'popupWindow': (context) => PopupWindowPage(),
        'charts': (context) => ChartsPage(),
        'customScrollView': (context) => CustomScrollViewPage(),
        'chartsBug': (context) => ChartsBugPage(),
      },
    );
  }
}
