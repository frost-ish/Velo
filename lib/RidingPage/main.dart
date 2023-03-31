import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:velo/Helpers/gps_service.dart';
import 'package:velo/HomePage/map.dart';
import 'package:velo/RidingPage/travel_info.dart';

import '../Helpers/stand.dart';
import '../QRCode/qr_code.dart';

class RidingPage extends StatefulWidget {
  @override
  State<RidingPage> createState() => _RidingPageState();
}

class _RidingPageState extends State<RidingPage> {
  bool isLocationAvailable = false;
  double? lat, long;

  @override
  void initState() {
    GPSService((double lat, double long) {
      setState(() {
        this.lat = lat;
        this.long = long;
        isLocationAvailable = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLocationAvailable
        ? MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  MyMap(lat, long, <Stand>[]),
                  Column(
                    children: [
                      Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: TravelInfo(),
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return QRCode(lat.toString(), lat.toString());
                            }));
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(12)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 196, 71, 55),
                            ),
                            elevation: MaterialStateProperty.all(4),
                          ),
                          child: Text(
                            'Finish ride',
                            style: TextStyle(
                                color: Color(0xFFF9F8FD), fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            body: Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator()),
          );
  }
}
