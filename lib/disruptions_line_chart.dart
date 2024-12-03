import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DisruptionsLineChart extends StatelessWidget {
  final List<charts.Series<DisruptionData, String>> seriesList;
  final bool animate;

  DisruptionsLineChart(this.seriesList, {this.animate = true});

  factory DisruptionsLineChart.sampleData(Map<String, int> disruptionsPerDay) {
    final data = disruptionsPerDay.entries.map((entry) {
      return DisruptionData(entry.key, entry.value);
    }).toList();

    return DisruptionsLineChart(
      [
        charts.Series<DisruptionData, String>(
          id: 'Perturbations',
          colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
          domainFn: (DisruptionData disruptions, _) => disruptions.day,
          measureFn: (DisruptionData disruptions, _) => disruptions.count,
          data: data,
        ),
      ],
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.OrdinalComboChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(),
      behaviors: [
        charts.ChartTitle('Perturbations par jour',
            behaviorPosition: charts.BehaviorPosition.top,
            titleStyleSpec: charts.TextStyleSpec(
              fontSize: 18,
              color: charts.MaterialPalette.black,
            ),
            titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
        charts.PanAndZoomBehavior(),
      ],
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.black,
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec:
        charts.BasicNumericTickProviderSpec(desiredTickCount: 5),
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.black,
          ),
          lineStyle: charts.LineStyleSpec(
            dashPattern: [4, 4],
            color: charts.MaterialPalette.gray.shade300,
          ),
        ),
      ),
    );
  }
}

class DisruptionData {
  final String day;
  final int count;

  DisruptionData(this.day, this.count);
}
