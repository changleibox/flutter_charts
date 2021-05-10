import 'dart:math';

import 'package:flatterer/flatterer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Created by box on 3/14/21.
///
/// 统计图
class ChartsPage extends StatefulWidget {
  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  Future<List<ChartSeries<dynamic, dynamic>>> _series;

  @override
  void initState() {
    _series = _request();
    super.initState();
  }

  @override
  void reassemble() {
    setState(() {
      _series = _request();
    });
    super.reassemble();
  }

  Future<List<ChartSeries<dynamic, dynamic>>> _request() async {
    final chartData = await compute(defaultData, 40);
    return getDefaultData(
      chartData: chartData,
      isDataLabelVisible: true,
      isMarkerVisible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SyncFusion Charts'),
      ),
      body: FutureBuilder<List<ChartSeries<dynamic, dynamic>>>(
        future: _series,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return ListView.separated(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final _tooltipKey = GlobalKey<OverlayWindowContainerState>();
              Rect rect;
              return AspectRatio(
                aspectRatio: 1.5,
                child: OverlayWindowContainer(
                  key: _tooltipKey,
                  backgroundColor: randomColor,
                  barrierDismissible: false,
                  direction: Axis.horizontal,
                  builder: (context) {
                    return Container(
                      width: 100,
                      height: 100,
                    );
                  },
                  child: SfCartesianChart(
                    title: ChartTitle(text: 'Flutter Chart'),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(
                      enable: false,
                    ),
                    borderWidth: 0,
                    borderColor: Colors.transparent,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(
                        width: 0,
                      ),
                    ),
                    primaryYAxis: NumericAxis(),
                    enableAxisAnimation: true,
                    selectionGesture: ActivationMode.singleTap,
                    selectionType: SelectionType.series,
                    onPointTapped: (pointTapArgs) {
                      // final points = pointTapArgs.dataPoints;
                      // final point = points[pointTapArgs.pointIndex] as CartesianChartPoint<dynamic>;
                      // final region = point.region.translate(10, 30);
                      // _tooltipKey.currentState?.show(region);
                    },
                    onTrackballPositionChanging: (trackballArgs) {
                      final point = trackballArgs.chartPointInfo.chartDataPoint;
                      final region = point.region.translate(10, 30);
                      if (rect == region) {
                        return;
                      }
                      rect = region;
                      _tooltipKey.currentState?.show(region);
                    },
                    onActualRangeChanged: (rangeChangedArgs) {
                      rect = null;
                      _tooltipKey.currentState?.dismiss();
                    },
                    zoomPanBehavior: ZoomPanBehavior(
                      enablePanning: true,
                      zoomMode: ZoomMode.x,
                      selectionRectBorderWidth: 2,
                      selectionRectBorderColor: Colors.red,
                      selectionRectColor: Colors.green,
                      enablePinching: true,
                      // maximumZoomLevel: 60000,
                      enableSelectionZooming: false,
                      enableDoubleTapZooming: true,
                    ),
                    trackballBehavior: TrackballBehavior(
                      enable: true,
                      shouldAlwaysShow: true,
                      lineWidth: 2,
                      lineColor: Colors.green,
                      activationMode: ActivationMode.singleTap,
                      tooltipSettings: const InteractiveTooltip(
                        enable: false,
                      ),
                    ),
                    series: [snapshot.data[index]],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          );
        },
      ),
    );
  }
}

/// 数据
List<SalesData> defaultData(int count) {
  return List.generate(count, (index) {
    return SalesData(
      DateTime(2021, 1, 1).add(Duration(days: index)),
      'China',
      Random().nextInt(100),
      Random().nextDouble(),
      Random().nextInt(100),
      Random().nextDouble(),
      Random().nextInt(100),
    );
  });
}

/// 数据
List<ChartSeries<dynamic, dynamic>> getDefaultData({
  bool isTooltipVisible = true,
  double lineWidth,
  bool isMarkerVisible = true,
  double markerWidth,
  double markerHeight,
  bool isDataLabelVisible = true,
  @required List<SalesData> chartData,
}) {
  assert(chartData != null);
  final color = randomColor;
  final gradient = LinearGradient(
    colors: [
      color,
      color.withOpacity(0.0),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  return <ChartSeries<dynamic, dynamic>>[
    BarSeries<SalesData, String>(
      enableTooltip: isTooltipVisible,
      dataSource: chartData,
      xValueMapper: (sales, _) => sales.formattedDate,
      yValueMapper: (sales, _) => sales.sales1,
      pointColorMapper: (datum, index) => randomColor,
      dataLabelMapper: (datum, index) => datum.name,
      width: lineWidth ?? 1,
      color: randomColor,
      borderWidth: 1,
      borderRadius: BorderRadius.circular(10),
      markerSettings: MarkerSettings(
        isVisible: isMarkerVisible,
        height: markerWidth ?? 4,
        width: markerHeight ?? 4,
        shape: DataMarkerType.circle,
        borderWidth: 3,
        borderColor: Colors.red,
      ),
      dataLabelSettings: DataLabelSettings(
        isVisible: isDataLabelVisible,
        labelAlignment: ChartDataLabelAlignment.auto,
      ),
    ),
    SplineAreaSeries<SalesData, String>(
      enableTooltip: isTooltipVisible,
      dataSource: chartData,
      xValueMapper: (sales, _) => sales.formattedDate,
      yValueMapper: (sales, _) => sales.sales2,
      gradient: gradient,
      markerSettings: MarkerSettings(
        isVisible: isMarkerVisible,
        height: markerWidth ?? 4,
        width: markerHeight ?? 4,
        shape: DataMarkerType.circle,
        borderWidth: 3,
        borderColor: Colors.black,
      ),
      dataLabelSettings: DataLabelSettings(
        isVisible: isDataLabelVisible,
        labelAlignment: ChartDataLabelAlignment.auto,
      ),
    ),
  ];
}

/// 数据
class SalesData {
  /// 构造函数
  const SalesData(
    this.date,
    this.name,
    this.sales1,
    this.sales2,
    this.sales3,
    this.sales4,
    this.sales5,
  );

  /// 日期
  final DateTime date;

  /// 国家
  final String name;

  /// value1
  final num sales1;

  /// value2
  final num sales2;

  /// value3
  final num sales3;

  /// value4
  final num sales4;

  /// value6
  final num sales5;

  /// 格式化的date
  String get formattedDate => DateFormat('yyyy年MM月dd日').format(date);
}

/// 随机颜色
Color get randomColor {
  final r = Random().nextInt(256);
  final g = Random().nextInt(256);
  final b = Random().nextInt(256);
  return Color.fromRGBO(r, g, b, 1.0);
}
