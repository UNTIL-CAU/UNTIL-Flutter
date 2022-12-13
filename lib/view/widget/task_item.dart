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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const CheckPointPage(),
                      //   ), //CheckPoint 페이지로
                      // );
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
                    itemCount: widget.task.checkpoints,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 90 / (widget.task.checkpoints)),
                        child: Container(
                          width: 10.0,
                          height: 10.0,
                          decoration: BoxDecoration(
                            color: index < widget.task.finishedCheckpoints ? (saturdayColor) : null,
                            shape: BoxShape.circle,
                            border: Border.all(color: saturdayColor, width: 2,),
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

