import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";

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
}

Future<Courses> createCourses(
    String email, String password, String school) async {
  try {
    final response = await http.post(
      Uri.parse('${Constants.url}/api/currentgrades'),
      body: json.encode({
        'email': email,
        "password": password,
        'highschool': school,
      }),
    );

    if (response.statusCode == 200) {
      return Courses.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error');
    }
  } catch (e) {
    return Courses.fromJson({
      'grades': [
        ["N/A", "N/A", "N/A", "100", "N/A"]
      ]
    });
  }
}

Future<Courses> modelCourse() async {
  await Future.delayed(const Duration(seconds: 2));
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
