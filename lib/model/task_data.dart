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

final List<TaskData> data = [
  TaskData(
    name: '캡스톤 디자인',
    startDate: Timestamp.fromDate(DateTime(2022, 9, 1)),
    endDate: Timestamp.fromDate(DateTime(2022, 12, 25)),
    tag: '팀 프로젝트',
    imminent: true,
    checkpoints: 9,
    finishedCheckpoints: 5,),
];

// final List<TaskData> data = [
//   TaskData(
//     '캡스톤 디자인',
//     Timestamp.fromDate(DateTime(2022, 9, 1)),
//     Timestamp.fromDate(DateTime(2022, 12, 25)),
//     '팀 프로젝트',
//     [
//       CheckPoint('기획', true, false, Timestamp.fromDate(DateTime(2022, 9, 10))),
//       CheckPoint('디자인', true, false, Timestamp.fromDate(DateTime(2022, 9, 18))),
//       CheckPoint('구성', true, true, Timestamp.fromDate(DateTime(2022, 9, 21))),
//       CheckPoint('회의', true, false, Timestamp.fromDate(DateTime(2022, 10, 5))),
//       CheckPoint('프론트', true, false, Timestamp.fromDate(DateTime(2022, 10, 11))),
//       CheckPoint('서버', false, false, Timestamp.fromDate(DateTime(2022, 12, 13))),
//       CheckPoint('대본', false, false, Timestamp.fromDate(DateTime(2022, 12, 13))),
//       CheckPoint('연동', false, false, Timestamp.fromDate(DateTime(2022, 12, 21))),
//       CheckPoint('발표', false, false, Timestamp.fromDate(DateTime(2022, 12, 27)))
//     ],
//     false,
//   ),
//   TaskData(
//     '모바일 앱 개발',
//     Timestamp.fromDate(DateTime(2022, 10, 2)),
//     Timestamp.fromDate(DateTime(2022, 12, 20)),
//     '앱 개발',
//     [
//       CheckPoint('기획', true, true, Timestamp.fromDate(DateTime(2022, 10, 3))),
//       CheckPoint('디자인', true, false, Timestamp.fromDate(DateTime(2022, 11, 28))),
//       CheckPoint('앱만들기', false, true, Timestamp.fromDate(DateTime(2022, 12, 12)))
//     ],
//     true,
//   ),
//   TaskData(
//     '최종 보고서',
//     Timestamp.fromDate(DateTime(2022, 12, 13)),
//     Timestamp.fromDate(DateTime(2022, 12, 31)),
//     '리포트',
//     [
//       CheckPoint('서론', false, false, Timestamp.fromDate(DateTime(2022, 12, 14))),
//       CheckPoint('본론', false, false, Timestamp.fromDate(DateTime(2022, 12, 20))),
//       CheckPoint('결론', false, false, Timestamp.fromDate(DateTime(2022, 12, 27)))
//     ],
//     false,
//   ),
// ];