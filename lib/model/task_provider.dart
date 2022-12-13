import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:until/model/task_data.dart';

class TaskProvider extends ChangeNotifier {
  TaskData _task = TaskData(
    name: '',
    startDate: Timestamp.now(),
    endDate: Timestamp.now(),
    tag: '',
    imminent: false,
    checkpoints: 0,
    finishedCheckpoints: 0,
  );

  final List<CheckPoint> _checkpoints = [];

  TaskData get task => _task;

  UnmodifiableListView<CheckPoint> get checkpoints => UnmodifiableListView(_checkpoints);

  void setTask(TaskData task) {
    _task = task;
    notifyListeners();
  }

  void addCheckpoint() {
    _checkpoints.add(CheckPoint(
      name: '',
      isFinished: false,
      isDelayed: false,
      untilDate: Timestamp.now(),
    ));
    notifyListeners();
  }

  void setCheckpointName(int index, String name) {
    _checkpoints[index].name = name;
    notifyListeners();
  }

  void setCheckpointDate(int index, Timestamp date) {
    _checkpoints[index].untilDate = date;
    notifyListeners();
  }

  bool get isEmpty => _checkpoints.isEmpty;

  int get length => _checkpoints.length;
}