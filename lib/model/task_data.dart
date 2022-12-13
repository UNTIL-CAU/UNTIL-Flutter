import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class TaskData {
  String name;
  Timestamp startDate;
  Timestamp endDate;
  String tag;
  List<CheckPoint> checkPoints;
  bool imminent;

  TaskData(this.name, this.startDate, this.endDate, this.tag,
      this.checkPoints, this.imminent);
}

class CheckPoint {
  String name;
  bool isFinished;
  bool isDelayed;
  Timestamp untilDate;

  CheckPoint(this.name, this.isFinished, this.isDelayed, this.untilDate);
}

final List<TaskData> data = [
  TaskData(
    '캡스톤 디자인',
    Timestamp.fromDate(DateTime(2022, 9, 1)),
    Timestamp.fromDate(DateTime(2022, 12, 25)),
    '팀 프로젝트',
    [
      CheckPoint('기획', true, false, Timestamp.fromDate(DateTime(2022, 9, 10))),
      CheckPoint('디자인', true, false, Timestamp.fromDate(DateTime(2022, 9, 18))),
      CheckPoint('구성', true, true, Timestamp.fromDate(DateTime(2022, 9, 21))),
      CheckPoint('회의', true, false, Timestamp.fromDate(DateTime(2022, 10, 5))),
      CheckPoint('프론트', true, false, Timestamp.fromDate(DateTime(2022, 10, 11))),
      CheckPoint('서버', false, false, Timestamp.fromDate(DateTime(2022, 12, 13))),
      CheckPoint('대본', false, false, Timestamp.fromDate(DateTime(2022, 12, 13))),
      CheckPoint('연동', false, false, Timestamp.fromDate(DateTime(2022, 12, 21))),
      CheckPoint('발표', false, false, Timestamp.fromDate(DateTime(2022, 12, 27)))
    ],
    false,
  ),
  TaskData(
    '모바일 앱 개발',
    Timestamp.fromDate(DateTime(2022, 10, 2)),
    Timestamp.fromDate(DateTime(2022, 12, 20)),
    '앱 개발',
    [
      CheckPoint('기획', true, true, Timestamp.fromDate(DateTime(2022, 10, 3))),
      CheckPoint('디자인', true, false, Timestamp.fromDate(DateTime(2022, 11, 28))),
      CheckPoint('앱만들기', false, true, Timestamp.fromDate(DateTime(2022, 12, 12)))
    ],
    true,
  ),
  TaskData(
    '최종 보고서',
    Timestamp.fromDate(DateTime(2022, 12, 13)),
    Timestamp.fromDate(DateTime(2022, 12, 31)),
    '리포트',
    [
      CheckPoint('서론', false, false, Timestamp.fromDate(DateTime(2022, 12, 14))),
      CheckPoint('본론', false, false, Timestamp.fromDate(DateTime(2022, 12, 20))),
      CheckPoint('결론', false, false, Timestamp.fromDate(DateTime(2022, 12, 27)))
    ],
    false,
  ),
];