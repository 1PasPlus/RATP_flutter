import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DisruptionsBarChart extends StatelessWidget {
  final Map<String, int> disruptionsPerDay;

  DisruptionsBarChart({required this.disruptionsPerDay});

  @override
  Widget build(BuildContext context) {
    // Préparation des données pour le graphique
    final List<charts.Series<BarData, String>> seriesList = [
      charts.Series<BarData, String>(
        id: 'Disruptions',
        domainFn: (BarData data, _) => data.label,
        measureFn: (BarData data, _) => data.value,
        colorFn: (BarData data, _) => data.color,
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
        charts.SelectNearest(), // Active la sélection de l'élément le plus proche
        charts.DomainHighlighter(), // Met en surbrillance la barre sélectionnée
      ],
      defaultRenderer: charts.BarRendererConfig<String>(
        // Configure les tooltips
        barRendererDecorator: charts.BarLabelDecorator<String>(), // Affiche des labels sur les barres
        cornerStrategy: const charts.ConstCornerStrategy(4), // Arrondit les coins des barres
      ),
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info, // Active le mode info pour les tooltips
          changedListener: (charts.SelectionModel<String> model) {
            if (model.hasDatumSelection) {
              // Récupération des données sélectionnées
              final selectedDatum = model.selectedDatum.first.datum as BarData;
              print('Selected: ${selectedDatum.label}, Value: ${selectedDatum.value}');
            }
          },
        ),
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
