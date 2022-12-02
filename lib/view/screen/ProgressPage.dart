import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:until/styles.dart';

import 'MainPage.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('TODAY'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),  //Add Task 페이지로
                );
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: const TopCalender()
    );
  }

}

class TopCalender extends StatefulWidget {
  const TopCalender({Key? key}) : super(key: key);

  @override
  State<TopCalender> createState() => _TopCalenderState();
}

class _TopCalenderState extends State<TopCalender> {

  TextStyle untilDateStyle = const TextStyle(
        color: mainColor, fontSize: 16, fontWeight: FontWeight.w600
  );


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
          children: [
            CalendarWeek(
              controller: CalendarWeekController(),
              height: 150,
              minDate: DateTime.now().add(
                Duration(days: -365),
              ),
              maxDate: DateTime.now().add(
                Duration(days: 365),
              ),
              dayOfWeekStyle: const TextStyle(color: mainColor, fontSize: 12),
              dayOfSaturStyle: const TextStyle(color: saturdayColor, fontSize: 12),
              dayOfSunStyle: const TextStyle(color: sundayColor, fontSize: 12),

              todayDateStyle: untilDateStyle,
              saturdayStyle: const TextStyle(
                  color: saturdayColor, fontSize: 16, fontWeight: FontWeight.w600
              ),
              sundayStyle: const TextStyle(
                  color: sundayColor, fontSize: 16, fontWeight: FontWeight.w600
              ),
              dateStyle: untilDateStyle,
              pressedDateStyle: untilDateStyle,
              pressedDateBackgroundColor: const Color(0xffdfe0ff),
              todayBackgroundColor: Colors.transparent,
              weekendsIndexes: [6],   //주말 하이라이트는 일요일만

              onDatePressed: (DateTime datetime) {
                // Do something
              },
              onDateLongPressed: (DateTime datetime) {
                // Do something
              },
              onWeekChanged: () {
                // Do something
              },
            ),
            const Text('알맹이'),
          ],
        )
    );
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}