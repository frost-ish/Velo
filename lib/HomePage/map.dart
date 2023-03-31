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
  late GoogleMapController gMapController;

  MyMap(this.lat, this.long, this.stands) {
    populateMarkers();
  }

  void relocateCamera(Stand stand) async {
    print(gMapController == null ? "NULLLLLLLLLLL" : "THEEKE BC");
    gMapController.animateCamera(CameraUpdate.newCameraPosition(
        const CameraPosition(target: LatLng(0, 0))));
    _controller.future.then(
      (value) {
        print("Controller Captured!");
      },
      onError: (error) {
        print(error.toString());
      },
    );
  }

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
        print("ASSIGNING CONTROLLER");
        gMapController = controller;
      },
    );
  }
}
