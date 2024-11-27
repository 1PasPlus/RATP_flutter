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
        color: Colors.blueGrey.withOpacity(0.2), // Light background for the tile
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
              color: Colors.blueGrey.withOpacity(0.5), // Semi-transparent header
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            padding: EdgeInsets.all(12.0),
            alignment: Alignment.center,
            child: Text(
              "Carte des perturbations",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
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
                              // Affiche une boîte de dialogue avec le message associé à la perturbation
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Détails de la perturbation"),
                                    content: Text(
                                      "Message: ${disruptions[index]['messages']}\n"
                                          "Gravité: ${disruptions[index]['severity']}",
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
