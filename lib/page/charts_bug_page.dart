import 'dart:math';

import 'package:flatterer/flatterer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/page/charts_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Created by box on 2021/5/15.
///
/// 重新SplineAreaCharts在数据全为0的情况下无法绘制的问题
class ChartsBugPage extends StatefulWidget {
  @override
  _ChartsBugPageState createState() => _ChartsBugPageState();
}

class _ChartsBugPageState extends State<ChartsBugPage> {
  final _tooltipKey = GlobalKey<OverlayWindowContainerState>();

  Rect _rect;

  List<MapEntry<String, num>> _dataSource;
  double _maxValue;
  double _minValue;

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  void _refresh() {
    final start = DateTime(2021, 1, 1);
    final random = Random();
    _dataSource = List.generate(100, (index) {
      final dateTime = start.add(Duration(days: index));
      return MapEntry<String, num>(
        dateTime.toString().split(' ').first,
        random.nextInt(4) * (index.isEven ? -1 : 1),
      );
    });
    final values = _dataSource.map((e) => e.value);
    _maxValue = values.fold(0, max).toDouble();
    _minValue = values.fold(0, min).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChartsBug'),
        actions: [
          CupertinoButton(
            onPressed: () {
              setState(_refresh);
            },
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            minSize: 0,
            child: const Icon(
              CupertinoIcons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: OverlayWindowContainer(
        key: _tooltipKey,
        backgroundColor: randomColor,
        // barrierDismissible: false,
        direction: Axis.horizontal,
        builder: (context) {
          return Container(
            width: 100,
            height: 100,
          );
        },
        onDismiss: () {
          _rect = null;
        },
        child: PointerInterceptor(
          child: SfCartesianChart(
            legend: Legend(isVisible: true),
            primaryXAxis: CategoryAxis(
              labelPlacement: LabelPlacement.onTicks,
              edgeLabelPlacement: EdgeLabelPlacement.none,
            ),
            primaryYAxis: NumericAxis(
              maximum: _maxValue == 0 && _minValue != 0 ? 0 : null,
              minimum: _minValue == 0 && _maxValue != 0 ? 0 : null,
            ),
            onTrackballPositionChanging: (trackballArgs) {
              final point = trackballArgs.chartPointInfo.chartDataPoint;
              final region = point.region.translate(10, 10);
              if (_rect == region) {
                return;
              }
              _rect = region;
              _tooltipKey.currentState?.show(
                region,
                behavior: TrackBehavior.sharp,
              );
            },
            onActualRangeChanged: (rangeChangedArgs) {
              _rect = null;
              _tooltipKey.currentState?.dismiss();
            },
            zoomPanBehavior: ZoomPanBehavior(
              zoomMode: ZoomMode.xy,
              enablePanning: true,
              enablePinching: true,
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
            series: [
              SplineAreaSeries<MapEntry<String, num>, String>(
                dataSource: _dataSource,
                xValueMapper: (datum, index) => datum.key,
                yValueMapper: (datum, index) => datum.value,
                splineType: SplineType.monotonic,
                borderWidth: 2,
                borderColor: Colors.red,
                borderDrawMode: BorderDrawMode.top,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.8),
                    Colors.blue.withOpacity(0.4),
                    Colors.blue.withOpacity(0.0),
                    Colors.blue.withOpacity(0.0),
                    Colors.blue.withOpacity(0.0),
                    Colors.blue.withOpacity(0.0),
                    Colors.blue.withOpacity(0.0),
                  ],
                  tileMode: TileMode.mirror,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                emptyPointSettings: EmptyPointSettings(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
