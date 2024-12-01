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
    if (widget.disruptedLines.isEmpty) {
      return Center(
        child: Text(
          'Aucune perturbation',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView(
      children: [
        Text(
          'Lignes perturbées',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.0),
        ...widget.disruptedLines.map((line) {
          String lineKey = line.idLine ?? '';
          bool isExpanded = expandedLines[lineKey] ?? false;

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ExpansionTile(
              title: Text(
                'Ligne ${line.shortNameLine ?? 'N/A'}',
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(Icons.train, color: Colors.indigo),
              children: getDisruptionMessages(line).map((message) {
                return ListTile(
                  title: Text(
                    message,
                    style: TextStyle(color: Colors.black87),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ],
    );
  }

  List<String> getDisruptionMessages(Line line) {
    Set<String> uniqueMessages = {};

    for (var disruption in widget.disruptions) {
      for (var impactedObject in disruption.impactedObjects ?? []) {
        if (impactedObject.type == 'line') {
          String? objectId = impactedObject.objectId;
          if (objectId != null) {
            String lineId = objectId.split('IDFM:').last.trim();
            if (lineId == line.idLine) {
              disruption.messages?.forEach((m) {
                String cleanedMessage = cleanMessage(m.text ?? '').trim();
                uniqueMessages.add(cleanedMessage);
              });
            }
          }
        }
      }
    }

    return uniqueMessages.toList();
  }
}

String cleanMessage(String message) {
  return message
      .replaceAll('&nbsp;', ' ')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll(RegExp(r'&[a-zA-Z0-9#]+;'), '');
}
