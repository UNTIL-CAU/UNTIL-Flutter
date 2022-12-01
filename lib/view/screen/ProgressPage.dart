import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CalendarWeek(
          controller: CalendarWeekController(),
          height: 150,
          showMonth: true,
          minDate: DateTime.now().add(
            Duration(days: -365),
          ),
          maxDate: DateTime.now().add(
            Duration(days: 365),
          ),

          onDatePressed: (DateTime datetime) {
            // Do something
          },
          onDateLongPressed: (DateTime datetime) {
            // Do something
          },
          onWeekChanged: () {
            // Do something
          },
          monthViewBuilder: (DateTime time) => Align(
            alignment: FractionalOffset.center,
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.yMMMM().format(time),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                )),
          ),
          decorations: [
            DecorationItem(
                decorationAlignment: FractionalOffset.bottomRight,
                date: DateTime.now(),
                decoration: Icon(
                  Icons.today,
                  color: Colors.blue,
                )),
            DecorationItem(
                date: DateTime.now().add(Duration(days: 3)),
                decoration: Text(
                  'Holiday',
                  style: TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.w600,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}