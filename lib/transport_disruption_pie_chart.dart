import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TransportDisruptionPieChart extends StatelessWidget {
  final Map<String, double> dataMap;

  TransportDisruptionPieChart({required this.dataMap});

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
        labelAccessorFn: (ChartData row, _) => '${row.value.toStringAsFixed(1)}%',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Répartition des perturbations',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: charts.PieChart<String>(
              seriesList,
              animate: true,
              defaultRenderer: charts.ArcRendererConfig(
                arcWidth: 60,
                arcRendererDecorators: [
                  charts.ArcLabelDecorator(
                    labelPosition: charts.ArcLabelPosition.inside,
                  ),
                ],
              ),
              behaviors: [
                charts.DatumLegend(
                  position: charts.BehaviorPosition.bottom,
                  outsideJustification: charts.OutsideJustification.middleDrawArea,
                  horizontalFirst: false,
                  desiredMaxRows: 1,
                  cellPadding: EdgeInsets.only(right: 8.0, bottom: 4.0),
                  entryTextStyle: charts.TextStyleSpec(
                    color: charts.MaterialPalette.black,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Couleurs pour chaque type de transport
  Color _getColorForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'bus':
        return Colors.teal;
      case 'metro':
        return Colors.orange;
      case 'rer':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

// Classe pour les données du graphique
class ChartData {
  final String label;
  final double value;
  final charts.Color color;

  ChartData(this.label, this.value, this.color);
}
