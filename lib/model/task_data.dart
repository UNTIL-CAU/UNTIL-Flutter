import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class TaskData {
  String name;
  Timestamp startDate;
  Timestamp endDate;
  String tag;
  bool imminent;
  int checkpoints;
  int finishedCheckpoints;

  TaskData({required this.name, required this.startDate, required this.endDate, required this.tag,
    required this.imminent, required this.checkpoints, required this.finishedCheckpoints});
}

class CheckPoint {
  String name;
  bool isFinished;
  bool isDelayed;
  Timestamp untilDate;

  CheckPoint({required this.name, required this.isFinished, required this.isDelayed, required this.untilDate});
}