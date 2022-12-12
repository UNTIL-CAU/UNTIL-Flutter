import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:until/service/local_notification.dart';
import 'package:until/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:until/view/screen/CheckPointPage.dart';
import 'package:until/view/screen/SignupPage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalNotification.initLocalNotificationPlugin();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "UNTIL",
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'NanumSquareNeo',
        colorScheme: ColorScheme.fromSeed(
          seedColor: mainColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'NanumSquareNeo',
        colorScheme: ColorScheme.fromSeed(
          seedColor: mainColor,
          brightness: Brightness.dark,
        ),
      ),
      home: const CheckPointPage(),
    );
  }
}
