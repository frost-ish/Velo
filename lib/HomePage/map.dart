import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Helpers/stand.dart';

class MyMap extends StatelessWidget {
  bool areMarkersAvailable = false;
  double? lat, long;
  var markers = <Marker>[].toSet();
  var stands = <Stand>[];
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  MyMap(this.lat, this.long, this.stands);

  void populateMarkers() {
    stands.forEach((element) {
      markers.add(element.marker!);
    });
  }

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
