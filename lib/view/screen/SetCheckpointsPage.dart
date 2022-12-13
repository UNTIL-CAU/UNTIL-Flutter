import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:until/view/screen/MainPage.dart';
import 'AddTaskPage.dart';
import 'MainPage.dart';

class SetCheckpointsPage extends StatelessWidget {
  final Data_Task _data;

  const SetCheckpointsPage(this._data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('SET CHECKPOINTS'),
      ),
      body: SetCheckpointsForm(_data),
      resizeToAvoidBottomInset: false,
    );
  }
}

class SetCheckpointsForm extends StatefulWidget {
  final Data_Task data;

  const SetCheckpointsForm(this.data, {Key? key}) : super(key: key);

  @override
  State<SetCheckpointsForm> createState() => _SetCheckpointsFormState();
}

class _SetCheckpointsFormState extends State<SetCheckpointsForm> {
  int ITEM_HEIGHT = 255;

  List<Data_Checkpoint> _checkpoints = [];
  final _setCheckpointKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Form(
              key: _setCheckpointKey,
              child: ListView(
                controller: _scrollController,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45, width: 1.0),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.data.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          '${widget.data.startDate} ~ ${widget.data.endDate}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(77, 87, 169, 1.0)),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  const Text(
                    "CheckPoints",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  if (_checkpoints.isEmpty) ...[
                    const SizedBox(
                      height: 175,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'There are no checkpoints.\nPlease add some checkpoints.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.black87,
                    ),
                    for (var i = 0; i < _checkpoints.length; i++)
                      CheckpointSetter(_checkpoints[i]),
                    const SizedBox(
                      height: 24,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: SizedBox(
                          width: 123,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_setCheckpointKey.currentState!.validate()) {
                                /**
                                 * _checkpoints[index].name, date => checkpoints 들의 이름, 날짜
                                 * _checkpoints[index].task. ~ => checkpoints들을 갖고 있는 task들의 data들
                                 * 
                                 * print(_checkpoints[0].name);
                                 * print(_checkpoints[0].date);
                                 */
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainPage(),
                                  ),
                                );
                              }
                            },
                            child: const Text('ADD TASK'),
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 15, 30),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: 60, height: 60),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.resolveWith(
                        (states) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.white70),
                      elevation:
                          MaterialStateProperty.resolveWith((states) => 3.0),
                    ),
                    onPressed: () async {
                      setState(
                        () {
                          _checkpoints.add(Data_Checkpoint(
                              _checkpoints.length, '', '', widget.data));
                        },
                      );
                      Future.delayed(
                        const Duration(milliseconds: 100),
                        () {
                          if (_scrollController.position.maxScrollExtent > 0) {
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent +
                                    ITEM_HEIGHT,
                                duration: Duration(milliseconds: 900),
                                curve: Curves.fastOutSlowIn);
                          }
                        },
                      );
                    },
                    child: const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.add,
                        size: 28.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckpointSetter extends StatefulWidget {
  Data_Checkpoint data;

  CheckpointSetter(this.data, {Key? key}) : super(key: key);

  @override
  State<CheckpointSetter> createState() => _CheckpointSetterState();
}

class _CheckpointSetterState extends State<CheckpointSetter> {
  TextEditingController _dateController = TextEditingController();

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
                  'CheckPoint ${widget.data.index + 1}',
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
                  widget.data.name = value!;
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
                          DateTime endDate =
                              DateTime.parse(widget.data.task.endDate);
                          DateTime startDate =
                              DateTime.parse(widget.data.task.startDate);
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
                          String formattedDate =
                              DateFormat("yyyy-MM-dd").format(pickedDate);

                          widget.data.date = formattedDate.toString();

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
