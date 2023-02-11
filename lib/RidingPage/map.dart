import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMap extends StatelessWidget {
  bool areMarkersAvailable = false;
  double? lat, long;
  var markers = <Marker>[].toSet();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  MyMap(this.lat, this.long, this.markers);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: markers,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(lat!, long!),
        zoom: 20,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
