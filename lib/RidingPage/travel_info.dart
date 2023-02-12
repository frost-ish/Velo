// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:velo/Helpers/theme.dart';
import 'package:velo/RidingPage/timer.dart';

class TravelInfo extends StatefulWidget {
  @override
  State<TravelInfo> createState() => _TravelInfoState();
}

class _TravelInfoState extends State<TravelInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 0.5)),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(46),
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 10, right: 10),
      child: Row(children: [
        Expanded(
          flex: 5,
          child: Text(
            '0 km',
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            '₹0',
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 5,
          child: RideTimer(),
        ),
      ]),
    );
  }
}
