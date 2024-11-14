import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DisruptionsBarChart extends StatelessWidget {
  final Map<String, int> disruptionsPerDay;

  DisruptionsBarChart({required this.disruptionsPerDay});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<DisruptionData, String>> series = [
      charts.Series(
        id: 'Perturbations',
        data: disruptionsPerDay.entries
            .map((entry) => DisruptionData(entry.key, entry.value))
            .toList(),
        domainFn: (DisruptionData data, _) => data.day,
        measureFn: (DisruptionData data, _) => data.count,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.orange),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Perturbations sur la semaine',
              style: TextStyle(fontSize: 18.0, color: Colors.orange, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: charts.BarChart(
                series,
                animate: true,
                vertical: true,
                domainAxis: charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                    labelRotation: 60,
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 12,
                      color: charts.MaterialPalette.black,
                    ),
                  ),
                ),
                primaryMeasureAxis: charts.NumericAxisSpec(
                  renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 12,
                      color: charts.MaterialPalette.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
