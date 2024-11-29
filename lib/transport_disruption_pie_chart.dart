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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Titre de la tuile
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Répartition des pannes par transport',
            style: TextStyle(
              fontSize: 20.0, // Même taille que le titre de gauche
              color: Colors.green.shade200, // Couleur de la tuile
              fontWeight: FontWeight.bold, // Même style
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Contenu : graphique et légende
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Graphique circulaire à gauche
              Expanded(
                flex: 3, // Plus grand espace pour le graphique
                child: charts.PieChart<String>(
                  seriesList,
                  animate: true,
                  defaultRenderer: charts.ArcRendererConfig(
                    arcWidth: 25, // Largeur du camembert
                    arcRendererDecorators: [],
                  ),
                ),
              ),
              // Légende à droite
              Expanded(
                flex: 2, // Moins d'espace pour la légende
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: dataMap.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getColorForLabel(entry.key),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${entry.value.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            entry.key,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
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
