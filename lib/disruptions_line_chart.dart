import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DisruptionsLineChart extends StatelessWidget {
  final List<charts.Series<DisruptionData, String>> seriesList; // Explicit type
  final bool animate;

  DisruptionsLineChart(this.seriesList, {this.animate = true});

  factory DisruptionsLineChart.sampleData() {
    return DisruptionsLineChart(
      [
        charts.Series<DisruptionData, String>(
          id: 'Perturbations',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (DisruptionData disruptions, _) => disruptions.day,
          measureFn: (DisruptionData disruptions, _) => disruptions.count,
          data: [
            DisruptionData('Lundi', 5),
            DisruptionData('Mardi', 8),
            DisruptionData('Mercredi', 2),
            DisruptionData('Jeudi', 7),
            DisruptionData('Vendredi', 10),
            DisruptionData('Samedi', 4),
            DisruptionData('Dimanche', 1),
          ],
        ),
      ],
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: charts.BarChart( // Use BarChart instead if LineChart still causes issues
        seriesList,
        animate: animate,
      ),
    );
  }
}

class DisruptionData {
  final String day; // String type for the x-axis
  final int count; // Integer type for the y-axis

  DisruptionData(this.day, this.count);
}
