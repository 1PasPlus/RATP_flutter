import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dashboard_tile.dart';
import 'disrupted_lines_tile.dart';
import 'transport_disruption_pie_chart.dart';
import 'disruptions_bar_chart.dart';
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

      // Load disruptions data
      String disruptionsData = await rootBundle.loadString('assets/disruptions.json');
      final disruptionsJson = json.decode(disruptionsData) as List;
      disruptions = disruptionsJson.map((json) => Disruption.fromJson(json)).toList();

      // Find disrupted lines
      disruptedLines = disruptions
          .expand((disruption) => disruption.impactedObjects ?? [])
          .where((obj) => obj.type == 'line')
          .map((obj) => obj.objectId?.split('IDFM:').last.trim())
          .where((id) => id != null && linesMap.containsKey(id))
          .map((id) => linesMap[id]!)
          .toList();

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
        'Lundi': 5,
        'Mardi': 8,
        'Mercredi': 2,
        'Jeudi': 7,
        'Vendredi': 10,
        'Samedi': 4,
        'Dimanche': 1,
      };

      setState(() {}); // Trigger UI update
    } catch (e) {
      print("Error loading data: $e");
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

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final allDisruptions = data['disruptions'] as List;

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
        }
      }
      setState(() {
        stopAreaDisruptions = tempDisruptions;
      });
    } catch (e) {
      print("Error fetching stop area disruptions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECFBF4), // Vert RATP pour le fond du dashboard
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // First row: Wide tile on the left, two smaller tiles on the right
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  // Wide tile on the left
                  Expanded(
                    flex: 2,
                    child: DashboardTile(
                      //title: disruptedLines.isEmpty ? 'Aucune perturbation' : 'Lignes perturbées',
                      //icon: disruptedLines.isEmpty ? Icons.check_circle : Icons.warning,
                      color: Colors.red.shade100,
                      child: disruptedLines.isEmpty
                          ? SizedBox()
                          : DisruptedLinesTile(
                        disruptedLines: disruptedLines,
                        disruptions: disruptions,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0), // Spacing
                  // Two smaller tiles stacked vertically on the right

                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: DashboardTile(
                            //title: 'Répartition des perturbations',
                            //icon: Icons.pie_chart,
                            color: Colors.green.shade100,
                            child: TransportDisruptionPieChart(),
                          ),
                        ),
                        SizedBox(height: 8.0), // Spacing
                        Expanded(
                          child: DashboardTile(
                            //title: 'Carte des perturbations',
                            //icon: Icons.map,
                            color: Colors.blueGrey.shade100,
                            child: stopAreaDisruptions.isEmpty
                                ? SizedBox()
                                : MapScreen(disruptions: stopAreaDisruptions),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0), // Spacing between rows
            // Second row: Full-width chart
            Expanded(
              flex: 2,
              child: DashboardTile(
                //title: 'Perturbations par jour',
                //icon: Icons.show_chart,
                color: Colors.blue.shade100,
                child: DisruptionsLineChart.sampleData(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}