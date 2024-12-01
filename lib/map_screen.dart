import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'animations/full_screen_map.dart';

class MapScreen extends StatelessWidget {
  final List<Map<String, String>> disruptions;

  MapScreen({required this.disruptions});

  @override
  Widget build(BuildContext context) {
    if (disruptions.isEmpty) {
      return Center(
        child: Text(
          'Chargement des perturbations...',
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FullScreenMap(disruptions: disruptions),
        ));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Hero(
          tag: "mapHero",
          child: SfMaps(
            layers: [
              MapTileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                initialFocalLatLng: const MapLatLng(48.8566, 2.3522),
                zoomPanBehavior: MapZoomPanBehavior(
                  zoomLevel: 10,
                ),
                initialMarkersCount: disruptions.length,
                markerBuilder: (BuildContext context, int index) {
                  double latitude = double.parse(disruptions[index]['latitude']!);
                  double longitude = double.parse(disruptions[index]['longitude']!);

                  return MapMarker(
                    latitude: latitude,
                    longitude: longitude,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.redAccent,
                      size: 24,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
