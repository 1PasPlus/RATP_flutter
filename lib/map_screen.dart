import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class MapScreen extends StatelessWidget {
  final List<Map<String, String>> disruptions;

  MapScreen({required this.disruptions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carte des perturbations"),
        backgroundColor: Colors.blueGrey,
      ),
      body: SfMaps(
        layers: [
          MapTileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            initialFocalLatLng: const MapLatLng(48.8566, 2.3522), // Centré sur Paris
            zoomPanBehavior: MapZoomPanBehavior(
              zoomLevel: 12,
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
    );
  }
}
