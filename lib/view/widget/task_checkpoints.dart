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

class CheckPoints extends StatefulWidget {
  final String taskName;
  final String userId;
  const CheckPoints({super.key, required this.taskName, required this.userId});

  @override
  State<CheckPoints> createState() => _CheckPointsState();
}

class _CheckPointsState extends State<CheckPoints> {
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
          return const Text("sorry, there is no checkPoint!");
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
                        visible: (index == 0),
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
                        //TODO: calculate todayIndex
                        visible: (index == 2),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
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
                        //TODO : calculate nextIndex
                        visible: (index == DateTime.now()),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
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
                // TODO : 인덱스값 받아서 position 설정하기
                // if (index == afterTodayIndex ||
                //     index == 0 ||
                //     index == untilTodayIndex) return 0.7;
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
