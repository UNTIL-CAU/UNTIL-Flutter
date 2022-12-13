// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:until/model/task_data.dart';
// import 'package:until/styles.dart';
// import 'package:intl/intl.dart';
// import 'package:timelines/timelines.dart';
// import 'MainPage.dart';
//
// const int data_index = 0;
//
// class CheckPointPage extends StatefulWidget {
//   const CheckPointPage({super.key});
//
//   @override
//   State<CheckPointPage> createState() => _CheckPointPageState();
// }
//
// class _CheckPointPageState extends State<CheckPointPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('TODAY'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const MainPage(),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.add),
//           ),
//         ],
//       ),
//       body: Container(
//         child: Column(
//           children: const [
//             Progress(),
//             CheckPoints(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Progress extends StatefulWidget {
//   const Progress({super.key});
//
//   @override
//   State<Progress> createState() => _ProgressState();
// }
//
// class _ProgressState extends State<Progress> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       height: 120,
//       decoration: BoxDecoration(
//         border: Border.all(
//             color: data[data_index].imminent ? sundayColor : Colors.black,
//             width: 1),
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.white,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               vertical: 2,
//             ), //apply padding to all four sides
//             child: Text(
//               '${DateFormat('MMMM dd').format(data[data_index].startDate.toDate())} ~ ${DateFormat('MMMM dd').format(data[data_index].endDate.toDate())}',
//               style: const TextStyle(color: saturdayColor),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 vertical: 2), //apply padding to all four sides
//             child: Text(
//               data[data_index].name,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 vertical: 2), //apply padding to all four sides
//             child: SizedBox(
//               height: 20,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: data[data_index].tag.length,
//                 itemBuilder: (BuildContext context, int indexTag) {
//                   return Text(
//                     '#${data[data_index].tag[indexTag]} ',
//                     style: const TextStyle(color: Colors.black54, fontSize: 12),
//                   );
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 vertical: 2), //apply padding to all four sides
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 SizedBox(
//                   height: 10,
//                   child: ListView.separated(
//                     shrinkWrap: true,
//                     scrollDirection: Axis.horizontal,
//                     separatorBuilder: (BuildContext context, int index) {
//                       return const SizedBox(
//                         height: 5,
//                       );
//                     },
//                     itemCount: data[data_index].checkPoints.length,
//                     itemBuilder: (BuildContext context, int indexPoint) {
//                       return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child:
//                               point(data[data_index].checkPoints[indexPoint]));
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// Widget point(CheckPoint checkPoint) => Container(
//       width: 10.0,
//       height: 10.0,
//       decoration: BoxDecoration(
//         color: checkPoint.isFinished
//             ? (checkPoint.isDelayed ? sundayColor : saturdayColor)
//             : null,
//         shape: BoxShape.circle,
//         border: Border.all(
//             color: checkPoint.isDelayed ? sundayColor : saturdayColor,
//             width: 2),
//       ),
//     );
//
// class CheckPoints extends StatefulWidget {
//   const CheckPoints({super.key});
//
//   @override
//   State<CheckPoints> createState() => _CheckPointsState();
// }
//
// class _CheckPointsState extends State<CheckPoints> {
//   String nowDate = DateFormat('MMMM dd').format(DateTime.now());
//   int untilTodayIndex = 0;
//   int afterTodayIndex = 0;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     untilTodayIndex = data[data_index].checkPoints.indexWhere(
//           (element) =>
//               nowDate == DateFormat('MMMM dd').format(element.untilDate.toDate()),
//         );
//     data[data_index].checkPoints.asMap().forEach((index, element) {
//       if (nowDate == DateFormat('MMMM dd').format(element.untilDate.toDate())) {
//         afterTodayIndex = index + 1;
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       fit: FlexFit.tight,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Flexible(
//             fit: FlexFit.tight,
//             child: Timeline.tileBuilder(
//               theme: TimelineThemeData(
//                 connectorTheme: const ConnectorThemeData(
//                   color: Colors.black26,
//                   thickness: 2.5,
//                 ),
//                 indicatorTheme: const IndicatorThemeData(
//                   color: mainColor,
//                 ),
//               ),
//               builder: TimelineTileBuilder.connected(
//                 contentsBuilder: (context, index) => Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 12,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Visibility(
//                           //OVERDUE
//                           visible: (index == 0),
//                           child: const Padding(
//                             padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
//                             child: Text(
//                               'OverDue',
//                               style: TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Visibility(
//                           //UNTIL TODAY
//                           visible: (index == untilTodayIndex),
//                           child: const Padding(
//                             padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
//                             child: Text(
//                               'UNTIL Today',
//                               style: TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Visibility(
//                           //NEXT
//                           visible: (index == afterTodayIndex),
//                           child: const Padding(
//                             padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
//                             child: Text(
//                               'NEXT Checkpoints',
//                               style: TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: double.infinity,
//                           child: Container(
//                             margin: const EdgeInsets.only(
//                               left: 10,
//                               right: 30,
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 25,
//                               vertical: 17,
//                             ),
//                             height: 100,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                   color: data[data_index]
//                                           .checkPoints[index]
//                                           .isFinished
//                                       ? Colors.black12
//                                       : mainColor,
//                                   width: 2),
//                               borderRadius: BorderRadius.circular(15),
//                               color: Colors.white,
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 setState(
//                                   () {
//                                     data[data_index]
//                                             .checkPoints[index]
//                                             .isFinished =
//                                         !data[data_index]
//                                             .checkPoints[index]
//                                             .isFinished;
//                                   },
//                                 );
//                               },
//                               child: SizedBox(
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: [
//                                     Text(
//                                       data[data_index].checkPoints[index].name,
//                                       style: const TextStyle(
//                                         color: Colors.black87,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       'UNTIL ${DateFormat('MMMM dd').format(data[data_index].checkPoints[index].untilDate.toDate())}',
//                                       style: const TextStyle(
//                                         color: mainColor,
//                                       ),
//                                     ),
//                                     data[data_index]
//                                             .checkPoints[index]
//                                             .isFinished
//                                         ? const Padding(
//                                             padding: EdgeInsets.only(top: 5),
//                                             child: Text("finished",
//                                                 textAlign: TextAlign.end,
//                                                 style: TextStyle(
//                                                   color: Colors.black38,
//                                                 )))
//                                         : const Text("")
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )),
//                 connectorBuilder: (context, index, type) =>
//                     const SolidLineConnector(),
//                 nodePositionBuilder: (context, index) => 0.12,
//                 indicatorPositionBuilder: (context, index) {
//                   if (index == afterTodayIndex ||
//                       index == 0 ||
//                       index == untilTodayIndex) return 0.7;
//                   return 0.5;
//                 },
//                 indicatorBuilder: (context, index) {
//                   {
//                     bool finish =
//                         data[data_index].checkPoints[index].isFinished;
//                     bool delay = data[data_index].checkPoints[index].isDelayed;
//
//                     if (finish) {
//                       if (delay) {
//                         return const DotIndicator(
//                           color: sundayColor,
//                         );
//                       }
//                       return const DotIndicator(
//                         color: mainColor,
//                       );
//                     } else {
//                       return const OutlinedDotIndicator(
//                         color: mainColor,
//                       );
//                     }
//                   }
//                 },
//                 itemCount: data[data_index].checkPoints.length,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
