// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:zenesus/serializers/courses.dart';
import 'package:zenesus/serializers/mps.dart';
import 'package:zenesus/serializers/gpas.dart';
import 'package:zenesus/serializers/coursedata.dart';
import 'package:zenesus/serializers/schedules.dart';
import 'package:zenesus/serializers/student.dart';
import 'package:zenesus/utils/cookies.dart';

DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

List<String> names = [
  "courses",
  "coursesData",
  "schedule",
  "student",
  "mps",
  "gpas"
];

void writeObject(Map<String, dynamic> json, int index) async {
  final prefs = await SharedPreferences.getInstance();
  String stringJson = jsonEncode(json);
  await prefs.setString(names[index], stringJson);
}

Future<Map<String, dynamic>> readObject(int index) async {
  final prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> objectMap =
      jsonDecode(prefs.getString(names[index]) ?? "{}");
  // dynamic objectObject = object.fromJson(objectMap);
  return objectMap;
}

void writeLastCache(DateTime datetime) async {
  String string = dateFormat.format(datetime);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("lastCache", string);
}

Future<DateTime> readlastCache() async {
  final prefs = await SharedPreferences.getInstance();
  String string = prefs.getString("lastCache") ?? "2000-01-01 0:42:00";
  DateTime dateTime = dateFormat.parse(string);
  return dateTime;
}

Future<bool> logicUpdateCache(DateTime currDatetime) async {
  DateTime oldDateTime = await readlastCache();
  if (oldDateTime.add(const Duration(hours: 1)).isBefore(currDatetime)) {
    writeLastCache(DateTime.now());
    //we need to update
    return false;
  }
  return true;
}
