import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class Ride {
  bool? inProgress;
  int? pointsEarned;
  String? stationEnd;
  String? stationStart;
  String? timeStart;
  String? timeEnd;
  String? user;
  DateTime? timeStartObj, timeEndObj;
  int? price;

  void calculateTime() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
    timeStartObj = dateFormat.parse(timeStart!);
    timeEndObj = dateFormat.parse(timeEnd!);
  }
}
