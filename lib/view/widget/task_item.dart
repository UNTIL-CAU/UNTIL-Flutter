import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:until/model/task_data.dart';
import 'package:until/styles.dart';
import 'package:until/view/screen/CheckPointPage.dart';
import 'package:until/view/widget/task_content.dart';

class TaskItem extends StatefulWidget {
  final TaskData task;
  const TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    Widget ok_btn = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('task')
                .where('name', isEqualTo: widget.task.name)
                .get()
                .then(
              (QuerySnapshot ss) {
                FirebaseFirestore.instance
                    .collection('task')
                    .doc(ss.docs[0].id)
                    .delete()
                    .then(
                      (doc) => print("deleted!"),
                      onError: (e) => print("Error updating document $e"),
                    );
              },
            );
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 13),
      height: widget.task.imminent ? 180 : 165,
      decoration: BoxDecoration(
        border: Border.all(
            color: widget.task.imminent ? sundayColor : Colors.black, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 7, child: TaskContent(task: widget.task)),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CheckPointPage(name: widget.task.name),
                      ), //CheckPoint 페이지로
                    );
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_right,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                0, 1, 10, 1), //apply padding to all four sides
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 27),
                  child: SizedBox(
                    height: 10,
                    child: IconButton(
                      onPressed: () {
                        AlertDialog alert = AlertDialog(
                          title: Text("삭제하시겠습니까?"),
                          content: Text("삭제 후 되돌릴 수 없습니다."),
                          actions: <Widget>[ok_btn],
                        );

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            });
                      }, //TODO: 여기부터
                      icon: const Icon(
                        Icons.delete,
                        color: mainColor,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: 10,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.task.checkpoints,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: 90 / (widget.task.checkpoints)),
                        child: Container(
                          width: 10.0,
                          height: 10.0,
                          decoration: BoxDecoration(
                            color: index < widget.task.finishedCheckpoints
                                ? (saturdayColor)
                                : null,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: saturdayColor,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
