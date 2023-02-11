import 'dart:async';

import 'package:flutter/material.dart';

import '../Helpers/theme.dart';

class RideTimer extends StatefulWidget {
  @override
  State<RideTimer> createState() => _RideTimerState();
}

class _RideTimerState extends State<RideTimer> {
  Duration duration = Duration();
  Timer? timer;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return buildTime();
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text(
      '$minutes:$seconds',
      style: TextStyle(
          color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (context) => addTime(1));
  }

  addTime(int secondsToAdd) {
    setState(() {
      final seconds = duration.inSeconds + secondsToAdd;
      duration = Duration(seconds: seconds);
    });
  }
}
