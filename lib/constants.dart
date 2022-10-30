import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static String? url = const String.fromEnvironment('URL',
      defaultValue: 'http://192.168.0.224:5000');
}

MaterialColor primaryColor = Colors.blue;
Color primaryColorColor = const Color.fromARGB(255, 33, 168, 245);
Color todoDeleteRed = Colors.red[800] ?? Colors.red;

final List<String> names = [
  "courses",
  "coursesData",
  "schedule",
  "student",
  "mps",
  "gpas"
];

String splitConstant = "|||||";

int gradesNavNum = 0;
int profileNavNum = 1;
int scheduleNavNum = 2;
int todoNavNum = 3;
