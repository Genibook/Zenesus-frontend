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
}

Future<Courses> modelCourse() async {
  await Future.delayed(const Duration(seconds: 5));
  return const Courses(courseGrades: [
    ["English 10 honors", "Ms.AppleGate", "appgate@mtsd.com", "100", "N/A"],
    ["AP Chemistry", "Ms.AppleGate", "appgate@mtsd.com", "100", "N/A"],
    ["Calculus AB", "Ms.AppleGate", "appgate@mtsd.com", "100", "N/A"],
    ["US 123123 12301203123", "Ms.AppleGate", "appgate@mtsd.com", "27", "N/A"],
    [
      "Photography",
      "Ms.AppleGate",
      "appgate@mtsd.com",
      "N/A",
      "Not Graded MP2"
    ],
    ["AP nuts", "Ms.AppleGate", "appgate@mtsd.com", "81", "N/A"],
    ["Calculus AB", "Ms.AppleGate", "appgate@mtsd.com", "99", "N/A"],
    ["IDK", "Ms.AppleGate", "appgate@mtsd.com", "71", "N/A"],
    ["o", "Ms.AppleGate", "appgate@mtsd.com", "61", "N/A"],
    ["AP Chemistry", "Ms.AppleGate", "appgate@mtsd.com", "98", "N/A"],
  ]);
}
