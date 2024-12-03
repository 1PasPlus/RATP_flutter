import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class FullScreenMap extends StatelessWidget {
  final List<Map<String, String>> disruptions;

  FullScreenMap({required this.disruptions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen interactive map
          Hero(
            tag: "mapHero", // Same tag for the transition
            child: SfMaps(
              layers: [
                MapTileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  initialFocalLatLng: const MapLatLng(48.8566, 2.3522), // Centré sur Paris
                  zoomPanBehavior: MapZoomPanBehavior(
                    zoomLevel: 9,
                    enablePanning: true, // Allow panning
                    enableDoubleTapZooming: true, // Enable zoom on double-tap
                  ),
                  initialMarkersCount: disruptions.length,
                  markerBuilder: (BuildContext context, int index) {
                    // Convertir les coordonnées en double
                    double latitude = double.parse(disruptions[index]['latitude']!);
                    double longitude = double.parse(disruptions[index]['longitude']!);

                    return MapMarker(
                      latitude: latitude,
                      longitude: longitude,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              // Nettoyage du message
                              String rawMessage = disruptions[index]['messages'] ?? "Message indisponible";
                              String cleanedMessage = rawMessage.replaceAll("\\n", "\n");

                              return AlertDialog(
                                title: Text(
                                  "Détails de la perturbation",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Affichage du message principal
                                    Text(
                                      "Message :",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      cleanedMessage,
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.justify,
                                    ),
                                    SizedBox(height: 12),
                                    // Affichage de la gravité
                                    Text(
                                      "Gravité :",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      disruptions[index]['severity'] ?? "Gravité inconnue",
                                      style: TextStyle(fontSize: 14, color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Fermer"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.location_on, color: Colors.red, size: 30),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Close button on top-right corner
          Positioned(
            top: 50.0,
            right: 20.0,
            child: FloatingActionButton(
              backgroundColor: Colors.white70,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.close, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
