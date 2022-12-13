import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:until/model/task_data.dart';
import 'package:until/shared_preference.dart';
import 'package:until/view/widget/task_item.dart';
import 'package:until/view/widget/task_checkpoints.dart';
import 'package:until/view/screen/AddTaskPage.dart';

class CheckPointPage extends StatefulWidget {
  final String name;
  const CheckPointPage({super.key, required this.name});

  @override
  State<CheckPointPage> createState() => _CheckPointPageState();
}

class _CheckPointPageState extends State<CheckPointPage> {
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
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Today'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddTaskPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: Container(
            child: Column(
              children: [
                Progress(
                  taskName: widget.name,
                  userId: userId.data!,
                ),
                CheckPoints(
                  taskName: widget.name,
                  userId: userId.data!,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Progress extends StatefulWidget {
  final String taskName;
  final String userId;
  const Progress({super.key, required this.taskName, required this.userId});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('task')
          .where('userId', isEqualTo: widget.userId)
          .where('name', isEqualTo: widget.taskName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Text("sorry, there is no task");
        }
        return TaskItem(
          task: TaskData(
            name: docs[0]['name'],
            startDate: docs[0]['start'],
            endDate: docs[0]['end'],
            tag: docs[0]['tag'],
            imminent: docs[0]['imminent'],
            checkpoints: docs[0]['checkpoints'],
            finishedCheckpoints: docs[0]['finishedCheckpoints'],
          ),
        );
      },
    );
  }
}
/** 
 * Index 참조
class _CheckPointsState extends State<CheckPoints> {
  String nowDate = DateFormat('MMMM dd').format(DateTime.now());
  int untilTodayIndex = 0;
  int afterTodayIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    untilTodayIndex = data[data_index].checkPoints.indexWhere(
          (element) =>
              nowDate ==
              DateFormat('MMMM dd').format(element.untilDate.toDate()),
        );
    data[data_index].checkPoints.asMap().forEach((index, element) {
      if (nowDate == DateFormat('MMMM dd').format(element.untilDate.toDate())) {
        afterTodayIndex = index + 1;
      }
    });
    super.initState();
  }
*/