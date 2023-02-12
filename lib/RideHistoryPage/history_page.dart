import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:velo/Helpers/theme.dart';
import 'package:dotted_line/dotted_line.dart';

import '../Helpers/ride.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  DateFormat dateFormat = DateFormat("hh:mma (dd ");
  var rides = <Ride>[];
  @override
  void initState() {
    fetchRides().then((value) {
      setState(() {});
    });
    super.initState();
  }

  Future<void> fetchRides() async {
    final snap = await FirebaseDatabase.instance
        .ref()
        .child("Rides")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (final snapshot in snap.children) {
      if (snapshot.child("inProgress").value == true) continue;
      Ride ride = Ride();
      ride.inProgress = snapshot.child("inProgress").value as bool?;
      ride.stationStart = snapshot.child("stationStart").value.toString();
      ride.stationEnd = snapshot.child("stationEnd").value.toString();
      ride.timeStart = snapshot.child("timeStart").value.toString();
      ride.timeEnd = snapshot.child("timeEnd").value.toString();
      ride.user = snapshot.child("user").value.toString();
      ride.price = int.parse(snapshot.child("price").value.toString());
      ride.calculateTime();
      rides.add(ride);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Ride History",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: rides.length,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          itemBuilder: (context, index) {
            Ride ride = rides[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              margin: EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: InkWell(
                splashFactory: InkRipple.splashFactory,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: Colors.green,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: SizedBox(
                                height: 22,
                                child: DottedLine(
                                  direction: Axis.vertical,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(ride.stationStart!),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    "${dateFormat.format(ride.timeStartObj!)}${months[(int.parse(DateFormat('MM').format(ride.timeStartObj!))) - 1]})",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              children: [
                                Text(ride.stationEnd!),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    "${dateFormat.format(ride.timeEndObj!)}${months[(int.parse(DateFormat('MM').format(ride.timeEndObj!))) - 1]})",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Text("₹${ride.price}"),
                            Text(
                                "${(ride.timeEndObj!.difference(ride.timeStartObj!).inSeconds ~/ 60) == 0 ? "00" : "${ride.timeEndObj!.difference(ride.timeStartObj!).inSeconds ~/ 60}"}:${ride.timeEndObj!.difference(ride.timeStartObj!).inSeconds % 60}")
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
        ),
      ),
    );
  }
}
