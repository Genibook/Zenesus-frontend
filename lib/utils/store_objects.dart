// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
