import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:velo/HomePage/main.dart';
import 'package:velo/firebase_options.dart';

class RideEndPage extends StatefulWidget {
  const RideEndPage({super.key});

  @override
  State<RideEndPage> createState() => _RideEndPageState();
}

class _RideEndPageState extends State<RideEndPage> {
  bool isDataLoaded = false;
  String? time;
  int? pointsEarned;

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  Future<void> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseDatabase.instance.ref().child("Users").child(uid).get();
    String rideId = snapshot.child("currentRide").value.toString();
    final snapshot2 = await FirebaseDatabase.instance
        .ref()
        .child("Rides")
        .child(rideId)
        .get();
    pointsEarned = int.parse(snapshot2.child("pointsEarned").value.toString());
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
    DateTime start =
        dateFormat.parse(snapshot2.child("timeStart").value.toString());
    DateTime end =
        dateFormat.parse(snapshot2.child("timeEnd").value.toString());
    time =
        "${(end.difference(start).inSeconds ~/ 60) == 0 ? "" : "${end.difference(start).inSeconds ~/ 60} minutes and "}${end.difference(start).inSeconds % 60} seconds.";
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: isDataLoaded
              ? SafeArea(
                  child: Column(
                    children: [
                      Container(
                        child: Image.asset('Assets/bikerider.png'),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                        child: Text(
                          'Voila!',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontFamily: 'Agne',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Text(
                          'You cycled for $time',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 50),
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Text(
                          'Points earned: $pointsEarned',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (ctx) => HomePage()),
                                (route) => false);
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(12)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 23, 138, 100),
                            ),
                            elevation: MaterialStateProperty.all(4),
                          ),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                                color: Color(0xFFF9F8FD), fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
