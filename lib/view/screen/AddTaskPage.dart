import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:until/model/task_data.dart';
import 'package:until/model/task_provider.dart';
import 'SetCheckpointsPage.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ADD TASK'),
      ),
      body: const AddTaskForm(),
      resizeToAvoidBottomInset: false,
    );
  }
}

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({Key? key}) : super(key: key);

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final _addTaskKey = GlobalKey<FormState>();

  String _taskName = '';
  Timestamp? _start;
  Timestamp? _end;
  String _tag = '';

  @override
  void initState() {
    super.initState();
    _startDateController.text = "";
    _endDateController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _addTaskKey,
          child: Stack(
            children: [
              ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Task Name',
                      helperText: '',
                    ),
                    onSaved: (value) {
                      _taskName = value!;
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please enter a task name.";
                      } else if (value.isEmpty) {
                        return "Please enter a task name.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Starts",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _startDateController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Date',
                        helperText: '',
                        suffixIcon: Icon(Icons.calendar_today)),
                    validator: (value) {
                      if (value == null) {
                        return "Please select a start date.";
                      } else if (value.isEmpty) {
                        return "Please select a start date.";
                      }
                      return null;
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
                        String formattedDate =
                            DateFormat("yyyy-MM-dd").format(pickedDate);
                        setState(() {
                            _startDateController.text = formattedDate.toString();
                            _start = Timestamp.fromDate(pickedDate);
                          },
                        );
                      } else {
                        print("Not selected");
                      }
                    },
                  ),
                  const Text(
                    "Ends",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _endDateController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Date',
                      helperText: '',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "Please select an end date.";
                      } else if (value.isEmpty) {
                        return "Please select an end date.";
                      } else {
                        DateTime start = DateTime.parse(value);
                        DateTime end =
                            DateTime.parse(_startDateController.text);
                        if (end.year > start.year ||
                            end.month > start.month ||
                            end.day > start.day) {
                          return "The end date is faster than the start date";
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
                        String formattedDate =
                            DateFormat("yyyy-MM-dd").format(pickedDate);
                        setState(() {
                          _endDateController.text = formattedDate.toString();
                          _end = Timestamp.fromDate(pickedDate);
                        });
                      } else {
                        print("Not selected");
                      }
                    },
                  ),
                  const SizedBox(height: 12,),
                  const Text(
                    "Tag",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tag',
                      helperText: '',
                    ),
                    onSaved: (value) {
                      _tag = value!;
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: SizedBox(
                    width: 188,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_addTaskKey.currentState!.validate()) {
                          _addTaskKey.currentState!.save();
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => SetCheckpointsPage(
                              task: TaskData(
                                name: _taskName,
                                startDate: _start!,
                                endDate: _end!,
                                tag: _tag,
                                imminent: false,
                                checkpoints: 0,
                                finishedCheckpoints: 0,
                              ),
                            ),
                          ),);
                        }
                      },
                      child: const Text(
                        'SET CHECKPOINTS',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
