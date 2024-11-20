import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TransportDisruptionPieChart extends StatelessWidget {
  // Données codées en dur pour le graphique
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
        // Graphique en doughnut
        Expanded(
          child: charts.PieChart<String>(
            seriesList,
            animate: true,
            defaultRenderer: charts.ArcRendererConfig(
              arcWidth: 20, // Largeur de l'anneau pour créer un effet doughnut
              startAngle: 4 / 5 * 3.14, // Optionnel : rotation du graphique
              arcRendererDecorators: [], // Pas d'étiquettes sur le graphique
            ),
          ),
        ),
        // Légende sous le graphique
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

  // Couleurs pour chaque type de transport
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

// Classe pour les données du graphique
class ChartData {
  final String label;
  final double value;
  final charts.Color color;

  ChartData(this.label, this.value, this.color);
}
