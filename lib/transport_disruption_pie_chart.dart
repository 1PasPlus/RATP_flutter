import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class TransportDisruptionPieChart extends StatelessWidget {
  final Map<String, double> dataMap;

  TransportDisruptionPieChart({required this.dataMap});

  final colorList = <Color>[
    Colors.blue, // Bus
    Colors.orange, // Métro
    Colors.green, // RER
  ];

  final transportModeLabels = {
    'bus': 'Bus',
    'metro': 'Métro',
    'rer': 'RER',
  };

  @override
  Widget build(BuildContext context) {
    // Filtrer les données pour n'inclure que les modes avec des pourcentages
    Map<String, double> filteredDataMap = {};
    dataMap.forEach((key, value) {
      if (transportModeLabels.containsKey(key)) {
        filteredDataMap[transportModeLabels[key]!] = value;
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blue),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Répartition des perturbations',
              style: TextStyle(fontSize: 18.0, color: Colors.blue, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: PieChart(
                dataMap: filteredDataMap,
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32.0,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                colorList: colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
                legendOptions: LegendOptions(
                  showLegends: false,
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: false,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Affichage des pourcentages sous le graphique
            Column(
              children: transportModeLabels.entries.map((entry) {
                String mode = entry.key;
                String label = entry.value;
                double percentage = dataMap[mode] ?? 0.0;
                return Text(
                  '$label: ${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 16.0),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
