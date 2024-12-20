import 'package:flutter/material.dart';
import 'models/line.dart';
import 'models/disruption.dart';

class DisruptedLinesTile extends StatefulWidget {
  final List<Line> disruptedLines;
  final List<Disruption> disruptions;

  DisruptedLinesTile({required this.disruptedLines, required this.disruptions});

  @override
  _DisruptedLinesTileState createState() => _DisruptedLinesTileState();
}

class _DisruptedLinesTileState extends State<DisruptedLinesTile> {
  Map<String, bool> expandedLines = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.red),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: widget.disruptedLines.isEmpty
            ? Center(
          child: Text(
            'Aucune perturbation',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : ListView(
          children: [
            Text(
              'Lignes perturbées',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            ...widget.disruptedLines.map((line) {
              String lineKey = line.idLine ?? '';
              bool isExpanded = expandedLines[lineKey] ?? false;

              return Column(
                children: [
                  ListTile(
                    title: Text(
                      'Ligne ${line.shortNameLine ?? 'N/A'}: ${line.nameLine ?? 'Nom indisponible'}',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                    onTap: () {
                      setState(() {
                        expandedLines[lineKey] = !isExpanded;
                      });
                    },
                  ),
                  if (isExpanded)
                    ...getDisruptionMessages(line).map((message) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: Text(
                          message,
                          style: TextStyle(color: Colors.black54),
                        ),
                      );
                    }).toList(),
                  Divider(),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  List<String> getDisruptionMessages(Line line) {
    List<String> messages = [];
    for (var disruption in widget.disruptions) {
      for (var impactedObject in disruption.impactedObjects ?? []) {
        if (impactedObject.type == 'line') {
          String? objectId = impactedObject.objectId;
          if (objectId != null) {
            String lineId = objectId.split('IDFM:').last.trim();
            if (lineId == line.idLine) {
              messages.addAll(disruption.messages?.map((m) => m.text ?? '').toList() ?? []);
            }
          }
        }
      }
    }
    return messages;
  }
}
