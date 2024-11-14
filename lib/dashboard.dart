import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard_tile.dart';
import 'disrupted_lines_tile.dart'; // Assurez-vous d'importer ce fichier
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

    // Afficher les identifiants des lignes perturbées
    print('Identifiants des lignes perturbées: $disruptedLineIds');

    // Récupérer les lignes perturbées
    disruptedLines = disruptedLineIds.map((id) => linesMap[id]).whereType<Line>().toList();

    print('Nombre de lignes perturbées trouvées: ${disruptedLines.length}'); // Debug

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
            // Les autres tuiles du tableau de bord
            DashboardTile(
              title: 'Informations 2',
              icon: Icons.bar_chart,
              color: Colors.green,
            ),
            DashboardTile(
              title: 'Informations 3',
              icon: Icons.pie_chart,
              color: Colors.orange,
            ),
            DashboardTile(
              title: 'Informations 4',
              icon: Icons.trending_up,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
