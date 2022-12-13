import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:until/model/task_data.dart';
import 'package:until/styles.dart';
import 'package:intl/intl.dart';
import 'AddTaskPage.dart';
import 'CheckPointPage.dart';

final List<TaskData> data = [
  TaskData(
      '캡스톤 디자인',
      DateTime(2022, 9, 1),
      DateTime(2022, 12, 25),
      ['팀 프로젝트', '앱 개발'],
      [
        CheckPoint('프론트', true, false, DateTime(2022, 10, 11)),
        CheckPoint('서버', false, true, DateTime(2022, 11, 21)),
        CheckPoint('연동', false, true, DateTime(2022, 12, 11)),
        CheckPoint('연동', false, true, DateTime(2022, 12, 13)),
        CheckPoint('연동', false, true, DateTime(2022, 12, 15)),
        CheckPoint('연동', false, true, DateTime(2022, 12, 15)),
        CheckPoint('연동', false, true, DateTime(2022, 12, 15)),
        CheckPoint('연동', false, true, DateTime(2022, 12, 15))
      ],
      true),
  TaskData(
      '모바일 앱 개발',
      DateTime(2022, 10, 2),
      DateTime(2022, 12, 20),
      ['팀 프로젝트', '앱 개발'],
      [
        CheckPoint('기획', true, true, DateTime(2022, 10, 03)),
        CheckPoint('디자인', true, false, DateTime(2022, 11, 28)),
        CheckPoint('앱만들기', false, true, DateTime(2022, 12, 12)),
        CheckPoint('연동', false, true, DateTime(2022, 12, 15)),
      ],
      true),
  TaskData(
      '최종 보고서',
      DateTime(2022, 12, 13),
      DateTime(2022, 12, 31),
      ['리포트', '발표'],
      [
        CheckPoint('서론', false, false, DateTime(2022, 12, 14)),
        CheckPoint('본론', false, false, DateTime(2022, 12, 20)),
        CheckPoint('연동', false, true, DateTime(2022, 12, 15)),
      ],
      false),
];

class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['A', 'B', 'C'];
    final List<int> colorCodes = <int>[600, 500, 100];

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('TODAY'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AddTaskPage()), //Add Task 페이지로
                );
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: Column(
          children: const [
            TopCalender(),
            ProgressList(),
          ],
        ));
  }
}

class TopCalender extends StatefulWidget {
  const TopCalender({Key? key}) : super(key: key);

  @override
  State<TopCalender> createState() => _TopCalenderState();
}

class _TopCalenderState extends State<TopCalender> {
  TextStyle untilDateStyle = const TextStyle(
      color: mainColor, fontSize: 16, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return CalendarWeek(
      controller: CalendarWeekController(),
      height: MediaQuery.of(context).size.width * 0.3,
      minDate: DateTime.now().add(
        const Duration(days: -365),
      ),
      maxDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      dayOfWeekStyle: const TextStyle(color: mainColor, fontSize: 12),
      dayOfSaturStyle: const TextStyle(color: saturdayColor, fontSize: 12),
      dayOfSunStyle: const TextStyle(color: sundayColor, fontSize: 12),

      todayDateStyle: untilDateStyle,
      saturdayStyle: const TextStyle(
          color: saturdayColor, fontSize: 16, fontWeight: FontWeight.w600),
      sundayStyle: const TextStyle(
          color: sundayColor, fontSize: 16, fontWeight: FontWeight.w600),
      dateStyle: untilDateStyle,
      pressedDateStyle: untilDateStyle,
      pressedDateBackgroundColor: const Color(0xffdfe0ff),
      todayBackgroundColor: Colors.transparent,
      weekendsIndexes: const [6], //주말 하이라이트는 일요일만

      onDatePressed: (DateTime datetime) {
        // Do something
      },
      onDateLongPressed: (DateTime datetime) {
        // Do something
      },
      onWeekChanged: () {
        // Do something
      },
    );
  }
}

class ProgressList extends StatefulWidget {
  const ProgressList({Key? key}) : super(key: key);

  @override
  _ProgressListState createState() => _ProgressListState();
}

class _ProgressListState extends State<ProgressList> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 30, 10),
        child: Text(
          'Currently in progress',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left,
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return TaskItem(data[index], context);
            }),
      ),
    ]);
  }
}

Widget TaskItem(TaskData task, BuildContext context) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 13),
      height: 161,
      decoration: BoxDecoration(
        border: Border.all(
            color: task.imminent ? sundayColor : Colors.black, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 7, child: TaskContent(task)),
              Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckPointPage(),
                        ), //CheckPoint 페이지로
                      );
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      size: 30,
                    ),
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 1, horizontal: 15), //apply padding to all four sides
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 10,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: task.checkPoints.length,
                    itemBuilder: (BuildContext context, int indexPoint) {
                      return Padding(
                          padding: EdgeInsets.only(
                              left: 90 / (task.checkPoints.length)),
                          child: Point(task.checkPoints[indexPoint]));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

Widget TaskContent(TaskData task) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 2), //apply padding to all four sides
          child: Text(
            '${DateFormat('MMMM dd').format(task.startDate)} ~ ${DateFormat('MMMM dd').format(task.endDate)}',
            style: const TextStyle(color: saturdayColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 2), //apply padding to all four sides
          child: Text(
            task.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 2), //apply padding to all four sides
          child: SizedBox(
            height: 20,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: task.tags.length,
                itemBuilder: (BuildContext context, int indexTag) {
                  return Text(
                    '#${task.tags[indexTag]} ',
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  );
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              0, 10, 0, 15), //apply padding to all four sides
          child: Visibility(
            visible: task.imminent,
            child: const Text(
              'The next checkpoint is imminent!',
              style: TextStyle(
                  color: sundayColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );

Widget Point(CheckPoint checkPoint) => Container(
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
        color: checkPoint.isFinished
            ? (checkPoint.isDelayed ? sundayColor : saturdayColor)
            : null,
        shape: BoxShape.circle,
        border: Border.all(
            color: checkPoint.isDelayed ? sundayColor : saturdayColor,
            width: 2),
      ),
    );
