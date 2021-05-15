import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_charts/page/charts_page.dart';

/// Created by box on 5/9/21.
///
/// customScrollView示例
class CustomScrollViewPage extends StatefulWidget {
  @override
  _CustomScrollViewPageState createState() => _CustomScrollViewPageState();
}

class _CustomScrollViewPageState extends State<CustomScrollViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('customScrollView示例'),
      ),
      body: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.biggest.height;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: 300,
                    color: randomColor,
                    alignment: Alignment.center,
                    child: const Text('300PX'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 300,
                    color: randomColor,
                    alignment: Alignment.center,
                    child: const Text('300PX'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 300,
                    color: randomColor,
                    alignment: Alignment.center,
                    child: const Text('300PX'),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverPersistentHeaderDelegate(),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: height - 100 - MediaQuery.of(context).padding.bottom,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 200,
                          color: Colors.green,
                          alignment: Alignment.center,
                          child: Text('200PX$index'),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 0,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SafeArea(
                    top: false,
                    child: Container(
                      height: 50,
                      color: Colors.red,
                      alignment: Alignment.center,
                      child: const Text('Pinned'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ignore: unused_element
class _SliverSeparatorListView extends StatelessWidget {
  const _SliverSeparatorListView({
    Key key,
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.separatorBuilder,
  })  : assert(itemCount != null),
        assert(itemBuilder != null),
        assert(separatorBuilder != null),
        super(key: key);

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final itemIndex = index ~/ 2;
          Widget widget;
          if (index.isEven) {
            widget = itemBuilder(context, itemIndex);
          } else {
            widget = separatorBuilder(context, itemIndex);
            assert(() {
              if (widget == null) {
                throw FlutterError('separatorBuilder cannot return null.');
              }
              return true;
            }());
          }
          return widget;
        },
        childCount: _computeActualChildCount(itemCount),
      ),
    );
  }

  // Helper method to compute the actual child count for the separated constructor.
  static int _computeActualChildCount(int itemCount) {
    return max(0, itemCount * 2 - 1);
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 50,
      color: Colors.red,
      alignment: Alignment.center,
      child: const Text('Pinned'),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
