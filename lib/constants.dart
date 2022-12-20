import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static String url =
      const String.fromEnvironment('URL', defaultValue: '192.168.0.224:5000');
}

const MaterialColor primaryColor = Colors.blue;
Color? bdayColor = Colors.amberAccent[400];
Color primaryColorColor = const Color.fromARGB(255, 33, 168, 245);
Color todoDeleteRed = Colors.red[800] ?? Colors.red;

final List<String> names = [
  "courses",
  "coursesData",
  "schedule",
  "student",
  "mps",
  "gpas",
  "gpaHistory",
];

const firstTimeName = "firstTime?";

const String UPDATE_DRIVE_URL = "";

const String splitConstant = "|||||";

const int gradesNavNum = 1;
const int profileNavNum = 0;
const int scheduleNavNum = 2;
const int todoNavNum = 3;

const int gpaHistoryJsonNum = 0;
const bool WINDOWS_UPDATE = false;

const bool TEST_DATA = false;
const bool SHOWOFF = false;
