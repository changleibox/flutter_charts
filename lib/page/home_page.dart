import 'package:flutter/material.dart';

/// Created by box on 3/13/21.
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'popupWindow');
              },
              child: const Text('PopupWindow'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'charts');
              },
              child: const Text('SyncFusion Charts'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'customScrollView');
              },
              child: const Text('CustomScrollView'),
            ),
          ],
        ),
      ),
    );
  }
}
