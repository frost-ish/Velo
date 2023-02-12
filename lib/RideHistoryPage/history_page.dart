import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:velo/Helpers/theme.dart';
import 'package:dotted_line/dotted_line.dart';

import '../Helpers/ride.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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

    print('HIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII');

    for (final snapshot in snap.children) {
      if (snapshot.child("inProgress").value == true) continue;
      Ride ride = Ride();
      ride.inProgress = snapshot.child("inProgress").value as bool?;
      ride.stationStart = snapshot.child("stationStart").value.toString();
      ride.stationEnd = snapshot.child("stationEnd").value.toString();
      ride.timeStart = snapshot.child("timeStart").value.toString();
      ride.timeEnd = snapshot.child("timeEnd").value.toString();
      ride.user = snapshot.child("user").value.toString();
      ride.calculateTime();
      rides.add(ride);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kPrimaryColor),
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
                        SizedBox(
                          height: 30,
                          child: DottedLine(
                            direction: Axis.vertical,
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
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(ride.stationEnd!),
                        ),
                      ],
                    )
                  ],
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
