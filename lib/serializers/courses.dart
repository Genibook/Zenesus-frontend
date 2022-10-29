import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/utils/store_objects.dart';

// the current grades/courses.
class Courses {
  final List<dynamic> courseGrades;

  const Courses({
    required this.courseGrades,
  });

  int length() {
    return courseGrades.length;
  }

  factory Courses.fromJson(Map<String, dynamic> json) {
    return Courses(courseGrades: json['grades']);
  }

  Map<String, dynamic> toJson() {
    return {
      "grades": courseGrades,
    };
  }
}

Future<Courses> createCourses(
    String email, String password, String school, bool forceReload) async {
  int index = 0;
  Map<String, dynamic> cachedJson = await readObject(index);
  if (cachedJson.isNotEmpty && !forceReload) {
    if (await logicUpdateCache(DateTime.now()) || !forceReload) {
      Courses courses = Courses.fromJson(cachedJson);
      return courses;
    }
  }

  String mp = await mpInCookies();
  int numm = await numInCookies();
  try {
    final response = await http.post(
      Uri.parse('${Constants.url}/api/currentgrades'),
      body: json.encode({
        'email': email,
        "password": password,
        'highschool': school,
        'mp': mp,
        'user': numm
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      writeObject(json, index);
      return Courses.fromJson(json);
    } else {
      throw Exception('Error');
    }
  } catch (e) {
    //print(e);
    return Courses.fromJson({
      'grades': [
        ["N/A", "N/A", "N/A", "100", "N/A"]
      ]
    });
  }
}

Future<Courses> modelCourse() async {
  await Future.delayed(const Duration(seconds: 1));
  return const Courses(courseGrades: [
    ["English 10 honors", "Ms.AppleGate", "appgate@mtsd.com", "100", "N/A"],
    ["AP Chemistry", "Ms.AppleGate", "appgate@mtsd.com", "100", "N/A"],
    ["AP Calculus AB", "Ms.AppleGate", "appgate@mtsd.com", "100", "N/A"],
    ["CP US History", "Ms.AppleGate", "appgate@mtsd.com", "100", "N/A"],
    [
      "Photography 3",
      "Ms.AppleGate",
      "appgate@mtsd.com",
      "N/A",
      "Not Graded MP2"
    ],
    ["Spanish II", "Ms.AppleGate", "appgate@mtsd.com", "100", "N/A"],
  ]);
}
