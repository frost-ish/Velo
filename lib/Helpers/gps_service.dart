import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GPSService {
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  double? long, lat;
  bool hasLocation = false;
  late StreamSubscription<Position> positionStream;
  Function callback;

  GPSService(this.callback) {
    checkPermission().then((value) {
      getLocation();
    });
  }

  Future<void> checkPermission() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
    }
  }

  Future<void> getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    hasLocation = true;

    callback.call(position.latitude, position.longitude);

    // LocationSettings locationSettings = const LocationSettings(
    //   accuracy: LocationAccuracy.high,
    //   distanceFilter: 100,
    // );

    // StreamSubscription<Position> positionStream =
    //     Geolocator.getPositionStream(locationSettings: locationSettings)
    //         .listen((Position position) {
    //   setState(() {
    //     long = position.longitude.toString();
    //     lat = position.latitude.toString();
    //   });
    // });
  }

  Future<void> getAddress() async {}
}
