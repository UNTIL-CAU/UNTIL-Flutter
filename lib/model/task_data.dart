class TaskData {
  String name;
  DateTime startDate;
  DateTime endDate;
  List<String> tags;
  List<CheckPoint> checkPoints;
  bool imminent;

  TaskData(this.name, this.startDate, this.endDate, this.tags,
      this.checkPoints, this.imminent);
}

class CheckPoint {
  String name;
  bool isFinished;
  bool isDelayed;
  DateTime untilDate;

  CheckPoint(this.name, this.isFinished, this.isDelayed, this.untilDate);
}