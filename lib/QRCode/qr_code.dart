import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velo/HomePage/main.dart';
import 'package:velo/RideEndPage/main.dart';
import 'package:velo/RidingPage/main.dart';

class QRCode extends StatefulWidget {
  String? lat, long;
  QRCode(this.lat, this.long);
  @override
  State<StatefulWidget> createState() => QRCodeState();
}

class QRCodeState extends State<QRCode> {
  bool? isRiding;
  bool isDataLoaded = false;
  @override
  void initState() {
    fetchRiderStatus().then((value) {
      setState(() {
        isDataLoaded = true;
        isRiding = value;
      });
      FirebaseDatabase.instance
          .ref()
          .child("Users")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child("isRiding")
          .onValue
          .listen((event) {
        if (isRiding == event.snapshot.value) {
        } else {
          isRiding = !isRiding!;
          if (isRiding!) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return RidingPage();
            }), (Route<dynamic> route) => false);
          } else {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return RideEndPage();
            }), (Route<dynamic> route) => false);
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // User user = FirebaseAuth.instance.currentUser!;
    return SafeArea(
        child: Scaffold(
      body: isDataLoaded
          ? Column(
              children: [
                Spacer(),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Scan the QR',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: QrImage(
                    data:
                        "uid=${FirebaseAuth.instance.currentUser!.uid}&lat=${widget.lat}&long=${widget.long}",
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
                Container(
                  child: Text(
                      'Use this QR to ${isRiding! ? "lock" : "unlock"} a bike'),
                ),
                Spacer(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      elevation: MaterialStateProperty.all(4),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFFF9F8FD), fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    ));
  }

  Future<bool> fetchRiderStatus() async {
    User user = FirebaseAuth.instance.currentUser!;
    final ref = FirebaseDatabase.instance.ref();
    final snapshot =
        await ref.child('Users').child(user.uid).child('isRiding').get();
    bool isRiding = snapshot.value! == true;
    return isRiding;
  }
}
