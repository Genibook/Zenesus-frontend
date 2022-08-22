import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";

class CoursesDatas {
  final List<CoursesData> datas;

  const CoursesDatas({required this.datas});

  factory CoursesDatas.fromJson(Map<String, dynamic> json) {
    List<CoursesData> items = [];
    for (dynamic data in json.values) {
      items.add(CoursesData.fromJson(data));
    }
    return CoursesDatas(datas: items);
  }
}

class CoursesData {
  final String mp;
  final String dayname;
  final String full_dayname;
  final String date;
  final String full_date;
  final dynamic teacher;
  final dynamic category;
  final dynamic assignment;
  final dynamic description;
  final dynamic grade_percent;
  final dynamic grade_num;
  final dynamic comment;
  final dynamic prev;
  final dynamic docs;
  final String course_name;

  const CoursesData({
    required this.course_name,
    required this.mp,
    required this.dayname,
    required this.full_dayname,
    required this.date,
    required this.full_date,
    required this.teacher,
    required this.category,
    required this.assignment,
    required this.description,
    required this.grade_percent,
    required this.grade_num,
    required this.comment,
    required this.prev,
    required this.docs,
  });

  factory CoursesData.fromJson(Map<String, dynamic> json) {
    return CoursesData(
        course_name: json['course_name'],
        mp: json['mp'],
        dayname: json['dayname'],
        date: json['date'],
        full_date: json['full_date'],
        full_dayname: json['full_date'],
        teacher: json['teacher'],
        category: json['category'],
        assignment: json['assignments'],
        description: json['description'],
        grade_percent: json['grade_percent'],
        grade_num: json["grade_num"],
        comment: json['comment'],
        prev: json['prev'],
        docs: json['docs']);
  }
}

Future<CoursesDatas> createCoursesDatas(
    String email, String password, String school, String mp) async {
  final response = await http.post(
    Uri.parse('${Constants.url}/api/courseinfos'),
    body: json.encode({
      'email': email,
      "password": password,
      'highschool': school,
      'mp': mp,
    }),
  );

  if (response.statusCode == 200) {
    return CoursesDatas.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error');
  }
}

Future<CoursesDatas> modelCourseDatas() async {
  await Future.delayed(const Duration(seconds: 5));
  return CoursesDatas.fromJson({
    '1': [
      {
        "course_name": "English 10 Honors",
        "mp": "MP2",
        "dayname": "Mon",
        "full_dayname": "Monday",
        "date": "6/7",
        "full_date": "6/7/2022",
        "teacher": "Ms.Applegate",
        "category": "Summative",
        "assignment": "Unit 10 Test",
        "description": "",
        "grade_percent": "100/100",
        "grade_num": "100",
        "comment": "",
        "prev": "",
        "docs": ""
      }
    ]
  });
}
