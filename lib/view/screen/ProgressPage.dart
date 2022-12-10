import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:until/styles.dart';
import 'package:intl/intl.dart';
import 'MainPage.dart';

class Data_Task {
  String name;
  DateTime startDate;
  DateTime endDate;
  List<String> tags;

  Data_Task(this.name, this.startDate, this.endDate, this.tags);
}

class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['A', 'B', 'C'];
    final List<int> colorCodes = <int>[600,500,100];

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopCalender(),
            const ProgressList(),
          ],
        )
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
    return CalendarWeek(
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
    );
  }
}

class ProgressList extends StatefulWidget {
  const ProgressList({Key? key}) : super(key: key);

  @override
  _ProgressListState createState() => _ProgressListState();
}

class _ProgressListState extends State<ProgressList> {

  final List<Data_Task> data = [
    new Data_Task('캡스톤 디자인', new DateTime(2022, 9, 1), new DateTime(2022, 12, 25), ['팀 프로젝트', '앱 개발']),
    new Data_Task('모바일 앱 개발', new DateTime(2022, 10, 2), new DateTime(2022, 12, 20), ['팀 프로젝트', '앱 개발']),
    new Data_Task('최종 보고서', new DateTime(2022, 12, 13), new DateTime(2022, 12, 31), ['리포트', '발표'])
  ];
  final bool imminent = true;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child:
              Text(
                'Currently in progress',
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
          ),

          Container(
            height: 450,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(8),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: imminent ? sundayColor : Colors.black,
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2), //apply padding to all four sides
                          child: Text(
                            '${DateFormat('MMMM dd').format(data[index].startDate)} ~ ${DateFormat('MMMM dd').format(data[index].endDate)}',
                            style: TextStyle(color: saturdayColor),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2), //apply padding to all four sides
                          child: Text(
                            '${data[index].name}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2), //apply padding to all four sides
                          child: Container(
                            height: 20,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data[index].tags.length,
                                itemBuilder: (BuildContext context, int indexTag){
                                  return Text(
                                    '#${data[index].tags[indexTag]} ',
                                    style: TextStyle(color: Colors.black54, fontSize: 12),
                                  );
                                }
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5), //apply padding to all four sides
                            child: Visibility(
                              visible: imminent,
                              child: Text(
                                'The next checkpoint is imminent!',
                                style: TextStyle(color: sundayColor, fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                            ),
                        ),
                      ],
                      ),
                  );
                }
            ),
          ),
        ]
    );
  }
}