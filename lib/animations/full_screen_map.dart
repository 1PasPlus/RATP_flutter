import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class FullScreenMap extends StatelessWidget {
  final List<Map<String, String>> disruptions;

  FullScreenMap({required this.disruptions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: "mapHero",
            child: SfMaps(
              layers: [
                MapTileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  initialFocalLatLng: const MapLatLng(48.8566, 2.3522),
                  zoomPanBehavior: MapZoomPanBehavior(
                    zoomLevel: 12,
                    enablePanning: true,
                    enableDoubleTapZooming: true,
                    enablePinching: true,
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
                        size: 28,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 40.0,
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
