import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:velo/Helpers/theme.dart';
import 'package:velo/HomePage/main.dart';
import 'package:velo/RidingPage/timer.dart';
import 'package:velo/firebase_options.dart';

class RideEndPage extends StatefulWidget {
  const RideEndPage({super.key});

  @override
  State<RideEndPage> createState() => _RideEndPageState();
}

class _RideEndPageState extends State<RideEndPage> {
  bool isDataLoaded = false;
  String? time;
  int? pointsEarned, price;

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
        .child(uid)
        .child(rideId)
        .get();
    pointsEarned = int.parse(snapshot2.child("pointsEarned").value.toString());
    price = int.parse(snapshot2.child("price").value.toString());
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
    DateTime start =
        dateFormat.parse(snapshot2.child("timeStart").value.toString());
    DateTime end =
        dateFormat.parse(snapshot2.child("timeEnd").value.toString());
    time =
        "${(end.difference(start).inSeconds ~/ 60) == 0 ? "00" : "${end.difference(start).inSeconds ~/ 60}"}:${end.difference(start).inSeconds % 60}";

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
                          "Here's your ride recap",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(46),
                        padding: EdgeInsets.only(
                            top: 16, bottom: 16, left: 10, right: 10),
                        child: Row(children: [
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                Icon(Icons.person_pin_circle),
                                Text(
                                  '0.5 km',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                Icon(Icons.currency_rupee),
                                Text(
                                  '₹0',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                Icon(Icons.timer),
                                Text(
                                  '$time',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ]),
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
                      Text(''),
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
