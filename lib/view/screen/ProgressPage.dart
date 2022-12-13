import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:provider/provider.dart';
import 'package:until/model/task_data.dart';
import 'package:until/shared_preference.dart';
import 'package:until/styles.dart';
import 'package:until/view/widget/task_item.dart';
import 'AddTaskPage.dart';

class dayChange with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void set(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => dayChange(),
      child: Scaffold(
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
          body: Stack(
            children: const [
              ProgressList(),
              TopCalender(),
            ],
          )),
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
      color: mainColor, fontSize: 16, fontWeight: FontWeight.w600);

  final CalendarWeekController _controller = CalendarWeekController();

  @override
  Widget build(BuildContext context) {
    return CalendarWeek(
      controller: _controller,
      height: 120,
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
        context.read<dayChange>().set(datetime);
      },
      onDateLongPressed: (DateTime datetime) {
        context.read<dayChange>().set(datetime);
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
  State<ProgressList> createState() => _ProgressListState();
}

class _ProgressListState extends State<ProgressList> {
  final _spfManager = SharedPrefManager();
  Future? future;

  Future<String?> initInfo() async {
    return await _spfManager.getUserId();
  }

  @override
  void initState() {
    super.initState();
    future = initInfo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, userId) {
        if (userId.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        print(context.watch<dayChange>()._selectedDate);
        return ListView(
          children: [
            const SizedBox(
              height: 100,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 30, 10),
              child: Text(
                'Currently in progress',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('task')
                  .where('userId', isEqualTo: userId.data!)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                var docs = snapshot.data!.docs;

                docs.removeWhere((element) => !(context
                        .read<dayChange>()
                        ._selectedDate
                        .isAfter(element['start'].toDate()) &&
                    context
                        .read<dayChange>()
                        ._selectedDate
                        .isBefore(element['end'].toDate())));

                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      "Sorry, There is no task.\nPlease add a new task.",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return TaskItem(
                      task: TaskData(
                        name: docs[index]['name'],
                        startDate: docs[index]['start'],
                        endDate: docs[index]['end'],
                        tag: docs[index]['tag'],
                        imminent: docs[index]['imminent'],
                        checkpoints: docs[index]['checkpoints'],
                        finishedCheckpoints: docs[index]['finishedCheckpoints'],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
