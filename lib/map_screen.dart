import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'animations/full_screen_map.dart';

class MapScreen extends StatelessWidget {
  final List<Map<String, String>> disruptions;

  MapScreen({required this.disruptions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Light background for the tile
        borderRadius: BorderRadius.circular(8.0), // Rounded corners for the entire tile
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2), // Light shadow for the tile
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias, // Ensure content respects rounded corners
      child: Column(
        children: [
          // Header with rounded corners
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Semi-transparent header
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            padding: EdgeInsets.all(12.0),
            alignment: Alignment.center,
            child: Text(
              "Perturbations accès handicapés",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          // Map with clickable functionality for full-screen transition
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FullScreenMap(disruptions: disruptions),
                ));
              },
              child: Hero(
                tag: "mapHero", // Unique tag for the transition
                child: SfMaps(
                  layers: [
                    MapTileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      initialFocalLatLng: const MapLatLng(48.8566, 2.3522), // Centré sur Paris
                      zoomPanBehavior: MapZoomPanBehavior(
                        zoomLevel: 9,
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
            ),
          ),
        ],
      ),
    );
  }
}