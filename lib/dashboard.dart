import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dashboard_tile.dart';
import 'disrupted_lines_tile.dart';
import 'transport_disruption_pie_chart.dart';
import 'disruptions_bar_chart.dart'; // Import du nouveau widget
import 'models/line.dart';
import 'models/disruption.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Line> lines = [];
  List<Disruption> disruptions = [];
  Map<String, Line> linesMap = {};
  List<Line> disruptedLines = [];

  Map<String, int> transportDisruptionCounts = {};
  Map<String, double> transportDisruptionPercentages = {};
  final List<String> transportModes = ['bus', 'metro', 'rer'];

  Map<String, int> disruptionsPerDay = {};

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    // Charger les données des lignes
    String linesData = await rootBundle.loadString('assets/lines.json');
    final linesJson = json.decode(linesData) as List;
    lines = linesJson.map((json) => Line.fromJson(json)).toList();

    print('Nombre de lignes chargées: ${lines.length}'); // Debug

    // Créer un map pour un accès rapide aux lignes par idLine
    linesMap = {
      for (var line in lines)
        if (line.idLine != null) line.idLine!: line,
    };

    // Charger les données des perturbations
    String disruptionsData = await rootBundle.loadString('assets/disruptions.json');
    final disruptionsJson = json.decode(disruptionsData) as List;
    disruptions = disruptionsJson.map((json) => Disruption.fromJson(json)).toList();

    print('Nombre de perturbations chargées: ${disruptions.length}'); // Debug

    // Trouver les lignes perturbées
    Set<String> disruptedLineIds = {};
    for (var disruption in disruptions) {
      for (var impactedObject in disruption.impactedObjects ?? []) {
        if (impactedObject.type == 'line') {
          String? objectId = impactedObject.objectId;
          if (objectId != null) {
            // Extraction de l'identifiant de ligne
            String lineId = objectId.split('IDFM:').last.trim();

            // Debug: afficher l'identifiant extrait
            print('Identifiant de ligne extrait: "$lineId"');

            disruptedLineIds.add(lineId);
          }
        }
      }
    }

    // Récupérer les lignes perturbées
    disruptedLines = disruptedLineIds.map((id) => linesMap[id]).whereType<Line>().toList();

    print('Nombre de lignes perturbées trouvées: ${disruptedLines.length}'); // Debug

    // Calculer le nombre de perturbations par type de transport
    transportDisruptionCounts = {'bus': 0, 'metro': 0, 'rer': 0};

    for (var line in disruptedLines) {
      String? transportMode = line.transportMode?.toLowerCase();
      if (transportModes.contains(transportMode)) {
        transportDisruptionCounts[transportMode!] =
            transportDisruptionCounts[transportMode]! + 1;
      }
    }

    // Calculer le pourcentage de perturbations par type de transport
    int totalDisruptions = transportDisruptionCounts.values.fold(0, (a, b) => a + b);

    if (totalDisruptions > 0) {
      transportDisruptionPercentages = {
        for (var mode in transportModes)
          mode: (transportDisruptionCounts[mode]! / totalDisruptions) * 100
      };
    } else {
      transportDisruptionPercentages = {
        for (var mode in transportModes) mode: 0.0
      };
    }

    print('Pourcentages de perturbations par type de transport: $transportDisruptionPercentages');

    // Calculer le nombre de perturbations par jour
    DateTime now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);

    int todayDisruptions = 0;
    for (var disruption in disruptions) {
      // Supposons que 'updatedAt' est au format '20231118T184000'
      String? updatedAt = disruption.updatedAt;
      if (updatedAt != null) {
        try {
          DateTime disruptionDate = DateFormat('yyyyMMddTHHmmss').parse(updatedAt);
          String disruptionDay = DateFormat('yyyy-MM-dd').format(disruptionDate);
          if (disruptionDay == today) {
            todayDisruptions += disruption.messages?.length ?? 0;
          }
        } catch (e) {
          // Si le parsing échoue, passer à la perturbation suivante
          continue;
        }
      }
    }

    // Générer des perturbations aléatoires pour les 6 jours précédents
    disruptionsPerDay = {};
    for (int i = 6; i >= 0; i--) {
      DateTime day = now.subtract(Duration(days: i));
      String dayLabel = DateFormat('EEE', 'fr_FR').format(day); // Ex : 'lun.', 'mar.'
      if (i == 0) {
        disruptionsPerDay[dayLabel] = todayDisruptions;
      } else {
        disruptionsPerDay[dayLabel] = Random().nextInt(9) + 2; // Aléatoire entre 2 et 10
      }
    }

    print('Perturbations par jour: $disruptionsPerDay'); // Debug

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Nombre de colonnes
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            // Tuile en haut à gauche
            disruptedLines.isEmpty
                ? DashboardTile(
              title: 'Aucune perturbation',
              icon: Icons.check_circle,
              color: Colors.green,
            )
                : DisruptedLinesTile(
              disruptedLines: disruptedLines,
              disruptions: disruptions,
            ),
            // Tuile en haut à droite
            transportDisruptionPercentages.isEmpty
                ? DashboardTile(
              title: 'Aucune perturbation',
              icon: Icons.donut_large,
              color: Colors.blue,
            )
                : TransportDisruptionPieChart(
              dataMap: transportDisruptionPercentages,
            ),
            // Tuile en bas à gauche
            DashboardTile(
              title: 'Informations 3',
              icon: Icons.pie_chart,
              color: Colors.orange,
            ),
            // Tuile en bas à droite - Graphique à barres
            disruptionsPerDay.isEmpty
                ? DashboardTile(
              title: 'Aucune donnée',
              icon: Icons.bar_chart,
              color: Colors.orange,
            )
                : DisruptionsBarChart(
              disruptionsPerDay: disruptionsPerDay,
            ),
          ],
        ),
      ),
    );
  }
}
