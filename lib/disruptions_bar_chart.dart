import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DisruptionsBarChart extends StatelessWidget {
  final Map<String, int> disruptionsPerDay;

  DisruptionsBarChart({required this.disruptionsPerDay});

  @override
  Widget build(BuildContext context) {
    final List<charts.Series<BarData, String>> seriesList = [
      charts.Series<BarData, String>(
        id: 'Disruptions',
        domainFn: (BarData data, _) => data.label,
        measureFn: (BarData data, _) => data.value,
        colorFn: (BarData data, _) => charts.ColorUtil.fromDartColor(
          data.label == 'Lundi' ? Color(0xFF8E44AD) : Color(0xFF3498DB),
        ),
        data: disruptionsPerDay.entries.map((entry) {
          return BarData(
            label: entry.key,
            value: entry.value,
            color: charts.ColorUtil.fromDartColor(Colors.blue),
          );
        }).toList(),
      ),
    ];

    return charts.BarChart(
      seriesList,
      animate: true,
      behaviors: [
        charts.ChartTitle("Perturbations par jour",
            behaviorPosition: charts.BehaviorPosition.top,
            titleStyleSpec: charts.TextStyleSpec(fontSize: 14)),
      ],
    );
  }
}

class BarData {
  final String label;
  final int value;
  final charts.Color color;

  BarData({required this.label, required this.value, required this.color});
}
