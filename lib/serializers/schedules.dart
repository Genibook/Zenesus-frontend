import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";
import 'package:zenesus/utils/cookies.dart';

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
}

class ScheduleCoursesDatas {
  final List<List<ScheduleCoursesData>> datas;

  const ScheduleCoursesDatas({required this.datas});

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
}

Future<ScheduleCoursesDatas> createScheduleCoursesDatas(
    String email, String password, String school) async {
  int numm = await numInCookies();
  try {
    final response = await http.post(
      Uri.parse('${Constants.url}/api/courseinfos'),
      body: json.encode({
        'email': email,
        "password": password,
        'highschool': school,
        'user': numm
      }),
    );

    if (response.statusCode == 200) {
      return ScheduleCoursesDatas.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Server error');
    }
  } catch (e) {
    print(e);
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
