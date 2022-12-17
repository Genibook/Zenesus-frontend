import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/utils/store_objects.dart';
import 'package:zenesus/utils/http_utils.dart';

class ScheduleCoursesData {
  final String courseName;
  final String date;
  final String points;
  final String category;
  final String assignment;
  final String description;

  const ScheduleCoursesData({
    required this.courseName,
    required this.date,
    required this.points,
    required this.category,
    required this.assignment,
    required this.description,
  });

  factory ScheduleCoursesData.fromJson(Map<String, dynamic> json) {
    return ScheduleCoursesData(
        date: json["date"],
        courseName: json["course_name"],
        points: json["points"],
        category: json["category"],
        assignment: json["assignment"],
        description: json["description"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "category": category,
      "assignment": assignment,
      "description": description,
      "course_name": courseName,
      "points": points,
    };
  }
}

class ScheduleCoursesDatas {
  final List<List<ScheduleCoursesData>> datas;

  const ScheduleCoursesDatas({required this.datas});

  int schedulesLength() {
    return datas.length;
  }

  int oneScheduleLength(int index) {
    List<ScheduleCoursesData> data = datas[index];
    return data.length;
  }

  factory ScheduleCoursesDatas.fromJson(Map<String, dynamic> json) {
    List<ScheduleCoursesData> items = [];
    List<List<ScheduleCoursesData>> allItems = [];
    for (dynamic datas in json.values) {
      for (dynamic data in datas) {
        items.add(ScheduleCoursesData.fromJson(data));
      }
      allItems.add(items);
      items = [];
    }
    return ScheduleCoursesDatas(datas: allItems);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    List<Map<String, dynamic>> items = [];
    Map<String, dynamic> allItems = {};
    //List<CoursesData> data in datas
    for (int i = 0; i < datas.length; i++) {
      List<ScheduleCoursesData> data = datas[i];
      for (ScheduleCoursesData smolData in data) {
        items.add(jsonDecode(jsonEncode(smolData)));
      }
      allItems[i.toString()] = items;
      items = [];
    }
    // ignore: avoid_print
    print(allItems);
    return json;
  }
}

Future<ScheduleCoursesDatas> createScheduleCoursesDatas(
    String email, String password, String school, bool forceReload) async {
  int index = 2;
  Map<String, dynamic> cachedJson = await readObject(index);
  if (cachedJson.isNotEmpty && !forceReload) {
    if (await logicUpdateCache(
            DateTime.now(),
            BasicStudentInfo(
                email: email, password: password, school: school)) ||
        !forceReload) {
      ScheduleCoursesDatas courses = ScheduleCoursesDatas.fromJson(cachedJson);
      return courses;
    }
  }
  int numm = await numInCookies();
  try {
    final response = await http.post(
      getCorrectUri("/api/monthSchedule"),
      body: json.encode({
        'email': email,
        "password": password,
        'highschool': school,
        'user': numm
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      writeObject(json, index);
      return ScheduleCoursesDatas.fromJson(json);
    } else {
      throw Exception('Server error');
    }
  } catch (e) {
    //print(e);
    return ScheduleCoursesDatas.fromJson({
      "RANDOM COUSE NAME": [
        {
          "course_name": "N/A",
          "date": "N/A",
          "points": "25",
          "category": "N/A",
          "assignment": "N/A",
          "description": "",
        }
      ]
    });
  }
}
