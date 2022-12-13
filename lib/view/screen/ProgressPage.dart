import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:until/model/task_data.dart';
import 'package:until/styles.dart';
import 'package:intl/intl.dart';
import 'AddTaskPage.dart';
import 'CheckPointPage.dart';

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
            '${DateFormat('MMMM dd').format(task.startDate.toDate())} ~ ${DateFormat('MMMM dd').format(task.endDate.toDate())}',
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
            child: Text(
              '#${task.tag} ',
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
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
