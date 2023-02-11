import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../QRCode/qr_code.dart';
import '../firebase_options.dart';

class UserInfoBar extends StatefulWidget {
  String? name, address, lat, long, points;
  UserInfoBar(this.name, this.address, this.lat, this.long, this.points);
  @override
  State<StatefulWidget> createState() => UserInfoBarState();
}

class UserInfoBarState extends State<UserInfoBar> {
  @override
  void initState() {
    initializeFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 8.0,
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 5),
            alignment: Alignment.center,
            child: SizedBox(
              height: 4,
              width: 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 20, top: 15, bottom: 2),
            child: Text(
              'Ready to ride, ${widget.name}? 🚲',
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 20, bottom: 5),
            child: Text(
              '${widget.address}',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              "Ride Points Available: ${widget.points}",
              style: TextStyle(
                color: Color.fromARGB(255, 23, 138, 100),
              ),
            ),
          ),
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
                backgroundColor: MaterialStateProperty.all(
                  Color.fromARGB(255, 23, 138, 100),
                ),
                elevation: MaterialStateProperty.all(4),
              ),
              child: Text(
                'Start a ride',
                style: TextStyle(color: Color(0xFFF9F8FD), fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRCode(widget.lat, widget.long),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
