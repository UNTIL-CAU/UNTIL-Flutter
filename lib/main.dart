import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:until/styles.dart';
import 'package:until/view/screen/main_screen.dart';

void main() {
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
              brightness: Brightness.light),
          scaffoldBackgroundColor: Colors.white
      ),
      darkTheme: ThemeData(
          useMaterial3: true,
          fontFamily: 'NanumSquareNeo',
          colorScheme: ColorScheme.fromSeed(
              seedColor: mainColor,
              brightness: Brightness.dark
          )
      ),
      home: MainScreen(),
    );
  }
}
