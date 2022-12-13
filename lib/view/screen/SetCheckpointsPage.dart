import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:until/model/task_data.dart';
import 'package:until/model/task_provider.dart';
import 'package:until/shared_preference.dart';
import 'package:until/view/screen/ProgressPage.dart';
import 'package:until/view/widget/checkpoint_setter.dart';

class SetCheckpointsPage extends StatelessWidget {
  final TaskData task;
  const SetCheckpointsPage({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      builder: (builder, child) {
        return _SetCheckpointsPage(task: task);
      },
    );
  }
}

class _SetCheckpointsPage extends StatefulWidget {
  final TaskData task;
  const _SetCheckpointsPage({Key? key, required this.task}) : super(key: key);

  @override
  State<_SetCheckpointsPage> createState() => _SetCheckpointsPageState();
}

class _SetCheckpointsPageState extends State<_SetCheckpointsPage> {
  int ITEM_HEIGHT = 255;

  final _setCheckpointKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  final _spfManager = SharedPrefManager();
  Future? future;

  Future<String?> initInfo() async{
    return await _spfManager.getUserId();
  }

  @override
  void initState() {
    super.initState();
    context.read<TaskProvider>().setTask(widget.task);
    future = initInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('SET CHECKPOINTS'),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, userId) {
          if (userId.data == null){
            return const Center(child: CircularProgressIndicator());
          }
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
                        const SizedBox(height: 20,),
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
                                context.read<TaskProvider>().task.name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                '${DateFormat('MMMM dd').format(context.read<TaskProvider>().task.startDate.toDate())} ~ ${DateFormat('MMMM dd').format(context.read<TaskProvider>().task.endDate.toDate())}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(77, 87, 169, 1.0)),
                              ),
                              const SizedBox(height: 6,),
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
                        if (context.read<TaskProvider>().isEmpty) ...[
                          const SizedBox(height: 175,),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'There are no checkpoints.\nPlease add some checkpoints.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 20,),
                          const Divider(
                            thickness: 1,
                            color: Colors.black87,
                          ),
                          for (var i = 0; i < context.read<TaskProvider>().length; i++)
                            CheckpointSetter(index: i,),
                          const SizedBox(height: 24,),
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
                                      final newTaskRef = db.collection('task').doc();
                                      final _task = context.read<TaskProvider>().task;
                                      await newTaskRef.set({
                                        "name": _task.name,
                                        "userId": userId.data,
                                        "start": _task.startDate,
                                        "end": _task.endDate,
                                        "tag": _task.tag,
                                        "checkpoints": context.read<TaskProvider>().length,
                                        "finishedCheckpoints": _task.finishedCheckpoints,
                                        "imminent": _task.imminent,
                                      });
                                      for (int i = 0; i < context.read<TaskProvider>().length; i++){
                                        final newCheckpointRef = db.collection('checkpoint').doc();
                                        final _checkpoint = context.read<TaskProvider>().checkpoints[i];
                                        await newCheckpointRef.set({
                                          "name": _checkpoint.name,
                                          "userId": userId.data,
                                          "taskName": _task.name,
                                          "date": _checkpoint.untilDate,
                                          "isDelayed": _checkpoint.isDelayed,
                                          "isFinished": _checkpoint.isFinished,
                                        });
                                      }
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => const ProgressPage(),
                                      ),);
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
                            setState(() {
                              context.read<TaskProvider>().addCheckpoint();
                            },
                            );
                            Future.delayed(
                              const Duration(milliseconds: 100),
                                  () {
                                if (_scrollController.position.maxScrollExtent > 0) {
                                  _scrollController.animateTo(
                                      _scrollController.position.maxScrollExtent +
                                          ITEM_HEIGHT,
                                      duration: const Duration(milliseconds: 900),
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
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}