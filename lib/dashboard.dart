import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dashboard_tile.dart';
import 'disrupted_lines_tile.dart';
import 'transport_disruption_pie_chart.dart';
import 'map_screen.dart';
import 'disruptions_line_chart.dart';
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
  List<Map<String, String>> stopAreaDisruptions = [];
  Map<String, int> transportDisruptionCounts = {};
  Map<String, double> transportDisruptionPercentages = {};
  Map<String, int> disruptionsPerDay = {};
  final List<String> transportModes = ['bus', 'metro', 'rer'];
  final String apiKey = 'X81LtZyjIEWcHJEy26UvZgSrSmSOEdm4';

  bool isLoadingData = true; // Indicateur de chargement des données

  @override
  void initState() {
    super.initState();
    loadJsonData();
    fetchStopAreaDisruptions();
  }

  Future<void> loadJsonData() async {
    try {
      // Load lines data
      String linesData = await rootBundle.loadString('assets/lines.json');
      final linesJson = json.decode(linesData) as List;
      lines = linesJson.map((json) => Line.fromJson(json)).toList();
      linesMap = {for (var line in lines) if (line.idLine != null) line.idLine!: line};
      print('Lines loaded: ${lines.length}');

      // Load disruptions data
      String disruptionsData = await rootBundle.loadString('assets/disruptions.json');
      final disruptionsJson = json.decode(disruptionsData) as List;
      disruptions = disruptionsJson.map((json) => Disruption.fromJson(json)).toList();
      print('Disruptions loaded: ${disruptions.length}');

      // Find disrupted lines
      disruptedLines = disruptions
          .expand((disruption) => disruption.impactedObjects ?? [])
          .where((obj) => obj.type == 'line')
          .map((obj) => obj.objectId?.split('IDFM:').last.trim())
          .where((id) => id != null && linesMap.containsKey(id))
          .map((id) => linesMap[id]!)
          .toList();
      print('Disrupted lines count: ${disruptedLines.length}');

      // Calculate transport disruption counts
      transportDisruptionCounts = {'bus': 0, 'metro': 0, 'rer': 0};
      for (var line in disruptedLines) {
        String? mode = line.transportMode?.toLowerCase();
        if (transportModes.contains(mode)) {
          transportDisruptionCounts[mode!] = (transportDisruptionCounts[mode]! + 1);
        }
      }

      // Calculate percentages
      int totalDisruptions = transportDisruptionCounts.values.fold(0, (a, b) => a + b);
      transportDisruptionPercentages = totalDisruptions > 0
          ? transportDisruptionCounts.map((k, v) => MapEntry(k, v / totalDisruptions * 100))
          : {for (var mode in transportModes) mode: 0.0};

      // Static example for disruptions per day
      disruptionsPerDay = {
        'Lun': 5,
        'Mar': 8,
        'Mer': 2,
        'Jeu': 7,
        'Ven': 10,
        'Sam': 4,
        'Dim': 1,
      };

      setState(() {
        isLoadingData = false; // Données chargées
      });
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        isLoadingData = false; // Données chargées même en cas d'erreur
      });
    }
  }

  Future<void> fetchStopAreaDisruptions() async {
    try {
      final List<Map<String, String>> tempDisruptions = [];
      const int totalPagesToFetch = 4;

      for (int page = 0; page < totalPagesToFetch; page++) {
        final url =
            'https://prim.iledefrance-mobilites.fr/marketplace/v2/navitia/line_reports/line_reports?start_page=$page';
        final response = await http.get(Uri.parse(url), headers: {
          'Accept': 'application/json',
          'apikey': apiKey,
        }).timeout(const Duration(seconds: 10));

        print('Response status code: ${response.statusCode}');

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final allDisruptions = data['disruptions'] as List;

          print('Disruptions fetched: ${allDisruptions.length}');

          for (var disruption in allDisruptions) {
            for (var impactedObject in disruption['impacted_objects'] ?? []) {
              final ptObject = impactedObject['pt_object'];
              if (ptObject != null && ptObject['stop_area'] != null) {
                final stopArea = ptObject['stop_area'];
                final coord = stopArea['coord'];
                tempDisruptions.add({
                  'cause': disruption['cause'] ?? 'Cause inconnue',
                  'messages': (disruption['messages'] as List<dynamic>?)
                      ?.map((msg) => msg['text'])
                      .join("\\n") ??
                      'Pas de message disponible',
                  'severity': disruption['severity']?['name'] ?? 'Gravité inconnue',
                  'longitude': coord['lon'],
                  'latitude': coord['lat'],
                });
              }
            }
          }
        } else {
          print('Failed to load disruptions for page $page');
        }
      }
      setState(() {
        stopAreaDisruptions = tempDisruptions;
        print('Total stop area disruptions: ${stopAreaDisruptions.length}');
      });
    } catch (e) {
      print("Error fetching stop area disruptions: $e");
      setState(() {
        stopAreaDisruptions = []; // Réinitialiser la liste en cas d'erreur
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingData) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Tableau de Bord des Perturbations'),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // First row
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  // Left tile
                  Expanded(
                    flex: 2,
                    child: DashboardTile(
                      color: Colors.white,
                      child: disruptedLines.isEmpty
                          ? Center(
                        child: Text(
                          'Aucune perturbation',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                          : DisruptedLinesTile(
                        disruptedLines: disruptedLines,
                        disruptions: disruptions,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  // Right tiles
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: DashboardTile(
                            color: Colors.white,
                            child: TransportDisruptionPieChart(
                              dataMap: transportDisruptionPercentages,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Expanded(
                          child: DashboardTile(
                            color: Colors.white,
                            child: stopAreaDisruptions.isEmpty
                                ? Center(
                              child: Text(
                                'Chargement de la carte...',
                                style: TextStyle(color: Colors.black54),
                              ),
                            )
                                : MapScreen(disruptions: stopAreaDisruptions),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.0),
            // Second row
            Expanded(
              flex: 2,
              child: DashboardTile(
                color: Colors.white,
                child: DisruptionsLineChart.sampleData(disruptionsPerDay),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
