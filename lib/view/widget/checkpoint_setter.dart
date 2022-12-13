import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:until/model/task_data.dart';
import 'package:until/model/task_provider.dart';

class CheckpointSetter extends StatefulWidget {
  final int index;

  const CheckpointSetter({Key? key, required this.index}) : super(key: key);

  @override
  State<CheckpointSetter> createState() => _CheckpointSetterState();
}

class _CheckpointSetterState extends State<CheckpointSetter> {
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'CheckPoint ${widget.index + 1}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CheckPoint Name',
                  helperText: '',
                ),
                onChanged: (value) {
                  context.read<TaskProvider>().setCheckpointName(widget.index, value);
                },
                validator: (value) {
                  if (value == null) {
                    return "Please enter a checkpoint name.";
                  } else if (value.isEmpty) {
                    return "Please enter a checkpoint name.";
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Column(
                    children: const [
                      Text(
                        'UNTIL',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Date',
                        helperText: '',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "Please select a date.";
                        } else if (value.isEmpty) {
                          return "Please select a date.";
                        } else {
                          DateTime date = DateTime.parse(value);
                          DateTime endDate = context.read<TaskProvider>().task.endDate.toDate();
                          DateTime startDate = context.read<TaskProvider>().task.startDate.toDate();
                          if (startDate.year > date.year ||
                              startDate.month > date.month ||
                              startDate.day > date.day ||
                              endDate.year < date.year ||
                              endDate.month < date.month ||
                              endDate.day < date.day) {
                            return "CheckPoint date is over the bound";
                          } else {
                            return null;
                          }
                        }
                      },
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          String formattedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
                          context.read<TaskProvider>().setCheckpointDate(widget.index, Timestamp.fromDate(pickedDate));
                          setState(() {
                            _dateController.text = formattedDate.toString();
                          });
                        } else {
                          print("Not selected");
                        }
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        const Divider(thickness: 1, color: Colors.black87)
      ],
    );
  }
}