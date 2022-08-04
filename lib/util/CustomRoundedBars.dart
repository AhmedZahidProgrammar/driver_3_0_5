import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:driver_3_0_5/model/earninghistory.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // home: CustomRoundedBars (),
    );
  }
}

class CustomRoundedBars extends StatelessWidget {
  final List<dynamic> data;
  final bool? animate;

  CustomRoundedBars(this.data, {this.animate});

  @override
  Widget build(BuildContext context) {
    var seriesList = _createSampleData(data);

    return new charts.BarChart(
      seriesList,
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
        labelStyle: new charts.TextStyleSpec(
            fontSize: 12, // size in Pts.
            color: charts.MaterialPalette.white),
        lineStyle: charts.LineStyleSpec(
          dashPattern: [4, 5],

          color: charts.ColorUtil.fromDartColor(Colors.white),
        ),
      )),
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 12,
                  // size in Pts.
                  color: charts.MaterialPalette.white),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                color:
                    charts.ColorUtil.fromDartColor(Colors.white),
                thickness: 1,
              ))),
      animate: true,
      barGroupingType: charts.BarGroupingType.stacked,
      defaultRenderer: new charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(30)),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<Graph, String>> _createSampleData(dynamic data) {
    return [
      new charts.Series<Graph, String>(
        id: 'mileage1',
        // colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Colors.green),

        domainFn: (Graph graph, _) => graph.month!,
        measureFn: (Graph graph, _) => graph.monthEarning,
        data: data,
        fillColorFn: (Graph graph, _) =>
            charts.ColorUtil.fromDartColor(Colors.transparent),
      ),
      new charts.Series<Graph, String>(
        id: 'graph',
        // colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Colors.green),
        domainFn: (Graph graph, _) => graph.month!,
        measureFn: (Graph graph, _) => graph.monthEarning,
        data: data,
      ),
      new charts.Series<Graph, String>(
        id: 'graph2',
        // colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Colors.green),
        domainFn: (Graph graph, _) => graph.month!,
        measureFn: (Graph graph, _) => graph.monthEarning,
        data: data,
        fillColorFn: (Graph graph, _) =>
            charts.ColorUtil.fromDartColor(Colors.transparent),
      ),
    ];
  }
}
