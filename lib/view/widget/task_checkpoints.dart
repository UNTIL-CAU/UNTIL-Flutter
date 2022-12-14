import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:until/model/task_data.dart';
import 'package:until/shared_preference.dart';
import 'package:until/model/task_data.dart';
import 'package:until/view/widget/task_item.dart';
import 'package:until/styles.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import 'package:until/view/screen/AddTaskPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckPoints extends StatefulWidget {
  final String taskName;
  final String userId;
  const CheckPoints({super.key, required this.taskName, required this.userId});

  @override
  State<CheckPoints> createState() => _CheckPointsState();
}

class _CheckPointsState extends State<CheckPoints> {
  int untilTodayIndex = 9999;
  int nextIndex = 9999;
  int overDueIndex = 9999;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('checkpoint')
          .where('userId', isEqualTo: widget.userId)
          .where('taskName', isEqualTo: widget.taskName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(0, 230, 0, 0),
            child: Center(
              child: Text(
                "sorry, there is no checkPoint!",
              ),
            ),
          );
        }
        untilTodayIndex = docs.indexWhere((element) =>
            DateFormat('MMMM dd').format(DateTime.now()) ==
            DateFormat('MMMM dd').format(element['date'].toDate()));
        // -1 if not there is today
        if (untilTodayIndex == -1) {
          //today index가 없다면
        }
        nextIndex = docs.indexWhere((element) =>
            DateTime.now().difference(element['date'].toDate()).isNegative);

        if (untilTodayIndex == 0 || nextIndex == 0) {
          overDueIndex = -1;
        } else {
          overDueIndex = 0;
        }

        // Calculate Today Index, after Today index
        return Flexible(
          child: Timeline.tileBuilder(
            theme: TimelineThemeData(
              connectorTheme: const ConnectorThemeData(
                color: Colors.black26,
                thickness: 2.5,
              ),
              indicatorTheme: const IndicatorThemeData(
                color: mainColor,
              ),
            ),
            builder: TimelineTileBuilder.connected(
              contentsBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        //OVERDUE
                        visible: (index == overDueIndex),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 20, 20),
                          child: Text(
                            'OverDue',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        //UNTIL TODAY
                        visible: (index == untilTodayIndex),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 20, 20),
                          child: Text(
                            'UNTIL Today',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        //NEXT
                        visible: (index == nextIndex),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 20, 20),
                          child: Text(
                            'NEXT Checkpoints',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                            right: 30,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 17,
                          ),
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: docs[index]['isFinished']
                                    ? Colors.black12
                                    : mainColor,
                                width: 2),
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              bool isAllow = false;
                              if (index == 0) {
                                isAllow = true;
                              } else if (docs[index - 1]['isFinished']) {
                                isAllow = true;
                              }

                              if (isAllow) {
                                if (docs[index]['isFinished']) {
                                  // 완료취소
                                  var finishedNum = 0;
                                  var i = 0;
                                  for (i; i < docs.length; i++) {
                                    if (docs[i]['isFinished']) finishedNum++;
                                  }
                                  FirebaseFirestore.instance
                                      .collection('task')
                                      .where('userId', isEqualTo: widget.userId)
                                      .where('name', isEqualTo: widget.taskName)
                                      .get()
                                      .then((QuerySnapshot ss) {
                                    FirebaseFirestore.instance
                                        .collection('task')
                                        .doc(ss.docs[0].id)
                                        .update({
                                      'finishedCheckpoints': --finishedNum
                                    });
                                  });
                                } else {
                                  // 완료하기
                                  var finishedNum = 0;
                                  var i = 0;
                                  for (i; i < docs.length; i++) {
                                    if (docs[i]['isFinished']) finishedNum++;
                                  }
                                  FirebaseFirestore.instance
                                      .collection('task')
                                      .where('userId', isEqualTo: widget.userId)
                                      .where('name', isEqualTo: widget.taskName)
                                      .get()
                                      .then((QuerySnapshot ss) {
                                    FirebaseFirestore.instance
                                        .collection('task')
                                        .doc(ss.docs[0].id)
                                        .update({
                                      'finishedCheckpoints': ++finishedNum
                                    });
                                  });
                                }

                                FirebaseFirestore.instance
                                    // checkpoint finsh 설정
                                    .collection('checkpoint')
                                    .doc(snapshot.data!.docs[index].id)
                                    .update({
                                  'isFinished': !docs[index]['isFinished']
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "이전의 체크포인트를 먼저 완료해주세요!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: mainColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    docs[index]['name'],
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'UNTIL ${DateFormat('MMMM dd').format(docs[index]['date'].toDate())}',
                                    style: const TextStyle(
                                      color: mainColor,
                                    ),
                                  ),
                                  docs[index]['isFinished']
                                      ? const Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text("finished",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                color: Colors.black38,
                                              )))
                                      : const Text("")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              connectorBuilder: (context, index, type) =>
                  const SolidLineConnector(),
              nodePositionBuilder: (context, index) => 0.12,
              indicatorPositionBuilder: (context, index) {
                if (index == nextIndex ||
                    index == 0 ||
                    index == untilTodayIndex) return 0.7;
                return 0.5;
              },
              indicatorBuilder: (context, index) {
                {
                  bool finish = docs[index]['isFinished'];
                  bool delay = docs[index]['isDelayed'];

                  if (finish) {
                    if (delay) {
                      return const DotIndicator(
                        color: sundayColor,
                      );
                    }
                    return const DotIndicator(
                      color: mainColor,
                    );
                  } else {
                    return const OutlinedDotIndicator(
                      color: mainColor,
                    );
                  }
                }
              },
              itemCount: docs.length,
            ),
          ),
        );
      },
    );
  }
}
