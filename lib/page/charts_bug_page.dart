import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Created by box on 2021/5/15.
///
/// 重新SplineAreaCharts在数据全为0的情况下无法绘制的问题
class ChartsBugPage extends StatelessWidget {
  /// 计算interval
  double computeInterval(Iterable<num> dataSource) {
    if (!dataSource.every((element) => element < 0)) {
      return null;
    }
    final values = List.of(dataSource.map((e) => e.abs()));
    final maxValue = values.reduce(max);
    final minValue = values.reduce(min);
    final difference = maxValue - minValue;
    final times = maxValue / difference;
    double interval;
    if (maxValue > 10 && (times.isInfinite || times > 20)) {
      interval = maxValue / 100;
    }
    return interval;
  }

  @override
  Widget build(BuildContext context) {
    final start = DateTime(2021, 1, 1);
    final dataSource = List.generate(100, (index) {
      final dateTime = start.add(Duration(days: index));
      return MapEntry<String, num>(
        dateTime.toString().split(' ').first,
        index == 0 ? 0 : -1000000000000000,
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChartsBug'),
      ),
      body: SfCartesianChart(
        legend: Legend(isVisible: true),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          interval: computeInterval(dataSource.map((e) => e.value)),
          isVisible: true,
        ),
        zoomPanBehavior: ZoomPanBehavior(
          zoomMode: ZoomMode.xy,
          enablePanning: true,
          enableDoubleTapZooming: true,
        ),
        series: [
          AreaSeries<MapEntry<String, num>, String>(
            dataSource: dataSource,
            xValueMapper: (datum, index) => datum.key,
            yValueMapper: (datum, index) => datum.value,
          ),
        ],
      ),
    );
  }
}
