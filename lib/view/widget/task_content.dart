import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:until/model/task_data.dart';
import 'package:until/styles.dart';

class TaskContent extends StatefulWidget {
  final TaskData task;
  const TaskContent({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskContent> createState() => _TaskContentState();
}

class _TaskContentState extends State<TaskContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 2), //apply padding to all four sides
          child: Text(
            '${DateFormat('MMMM dd').format(widget.task.startDate.toDate())} ~ ${DateFormat('MMMM dd').format(widget.task.endDate.toDate())}',
            style: const TextStyle(color: saturdayColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 2), //apply padding to all four sides
          child: Text(
            widget.task.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 2), //apply padding to all four sides
          child: SizedBox(
            height: 20,
            child: Text(
              '#${widget.task.tag} ',
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              0, 10, 0, 15), //apply padding to all four sides
          child: Visibility(
            visible: widget.task.imminent,
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
  }
}
