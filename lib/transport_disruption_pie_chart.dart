import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TransportDisruptionPieChart extends StatelessWidget {
  // Hardcoded data for the chart
  final Map<String, double> dataMap = {
    'Bus': 38.0,
    'Metro': 22.0,
    'Rer': 40.0,
  };

  @override
  Widget build(BuildContext context) {
    final List<charts.Series<ChartData, String>> seriesList = [
      charts.Series<ChartData, String>(
        id: 'Disruptions',
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        colorFn: (ChartData data, _) => data.color,
        data: dataMap.entries.map((entry) {
          final color = _getColorForLabel(entry.key);
          return ChartData(entry.key, entry.value, charts.ColorUtil.fromDartColor(color));
        }).toList(),
      ),
    ];

    return Column(
      children: [
        // Donut chart
        Expanded(
          child: charts.PieChart<String>(
            seriesList,
            animate: true,
            defaultRenderer: charts.ArcRendererConfig(
              arcWidth: 40, // Set width for donut effect
              startAngle: 4 / 5 * 3.14, // Optional: Rotate the chart
              arcRendererDecorators: [], // No labels on the chart itself
            ),
          ),
        ),
        // Legend below the chart
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: dataMap.entries.map((entry) {
              return Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getColorForLabel(entry.key),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${entry.value.toStringAsFixed(0)}%',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    entry.key,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Color _getColorForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'bus':
        return Colors.blue;
      case 'metro':
        return Colors.orange;
      case 'rer':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class ChartData {
  final String label;
  final double value;
  final charts.Color color;

  ChartData(this.label, this.value, this.color);
}
