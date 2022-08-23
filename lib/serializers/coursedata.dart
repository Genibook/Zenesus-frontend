import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";

class CoursesDatas {
  final List<List<CoursesData>> datas;

  const CoursesDatas({required this.datas});

  factory CoursesDatas.fromJson(Map<String, dynamic> json) {
    List<CoursesData> items = [];
    List<List<CoursesData>> allItems = [];
    for (dynamic datas in json.values) {
      for (dynamic data in datas) {
        items.add(CoursesData.fromJson(data));
      }
      allItems.add(items);
      items = [];
    }
    return CoursesDatas(datas: allItems);
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
        assignment: json['assignment'],
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
  try {
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
  } catch (e) {
    print(e);
    return CoursesDatas.fromJson({
      '1': [
        {
          "course_name": "N/A",
          "mp": "N/A",
          "dayname": "N/A",
          "full_dayname": "N/A",
          "date": "N/A",
          "full_date": "N/A",
          "teacher": "N/A",
          "category": "N/A",
          "assignment": "N/A",
          "description": "N/A",
          "grade_percent": "N/A",
          "grade_num": "N/A",
          "comment": "N/A",
          "prev": "N/A",
          "docs": "N/A"
        }
      ]
    });
  }
}

Future<CoursesDatas> modelCourseDatas() async {
  await Future.delayed(const Duration(seconds: 1));
  return CoursesDatas.fromJson({
    '0': [
      {
        "course_name": "English 10 honors",
        "mp": "MP2",
        "dayname": "Wed",
        "full_dayname": "Monday",
        "date": "6/7",
        "full_date": "6/7/2022",
        "teacher": "Ms.Applegate",
        "category": "Summative",
        "assignment": "Unit 10 Test",
        "description": "you did well eddie :D",
        "grade_percent": "100",
        "grade_num": "100/100",
        "comment": "",
        "prev": "",
        "docs": ""
      },
      {
        "course_name": "English 10 honors",
        "mp": "MP2",
        "dayname": "Mon",
        "full_dayname": "Monday",
        "date": "6/7",
        "full_date": "6/7/2022",
        "teacher": "Ms.Applegate",
        "category": "Summative",
        "assignment": "Unit 10 Test",
        "description":
            "heheehawhaweheehawhaweheehawhaweheehawhaweheehawhaweheehawhaweheehawhaweheehawhaw",
        "grade_percent": "100",
        "grade_num": "100/100",
        "comment": "",
        "prev": "",
        "docs": ""
      },
      {
        "course_name": "English 10 honors",
        "mp": "MP2",
        "dayname": "Mon",
        "full_dayname": "Monday",
        "date": "6/7",
        "full_date": "6/7/2022",
        "teacher": "Ms.Applegate",
        "category": "Summative",
        "assignment": "Unit 10 Test",
        "description": "heheehawhaw",
        "grade_percent": "100",
        "grade_num": "100/100",
        "comment": "",
        "prev": "",
        "docs": ""
      },
      {
        "course_name": "English 10 honors",
        "mp": "MP2",
        "dayname": "Mon",
        "full_dayname": "Monday",
        "date": "6/7",
        "full_date": "6/7/2022",
        "teacher": "Ms.Applegate",
        "category": "Summative",
        "assignment": "Unit 10 Test",
        "description": "heheehawhaw",
        "grade_percent": "100",
        "grade_num": "100/100",
        "comment": "",
        "prev": "",
        "docs": ""
      },
      {
        "course_name": "English 10 honors",
        "mp": "MP2",
        "dayname": "Mon",
        "full_dayname": "Monday",
        "date": "6/7",
        "full_date": "6/7/2022",
        "teacher": "Ms.Applegate",
        "category": "Summative",
        "assignment": "Unit 10 Test",
        "description": "heheehawhaw",
        "grade_percent": "100",
        "grade_num": "100/100",
        "comment": "",
        "prev": "",
        "docs": ""
      },
      {
        "course_name": "English 10 honors",
        "mp": "MP2",
        "dayname": "Mon",
        "full_dayname": "Monday",
        "date": "6/7",
        "full_date": "6/7/2022",
        "teacher": "Ms.Applegate",
        "category": "Summative",
        "assignment": "Unit 10 Test",
        "description": "heheehawhaw",
        "grade_percent": "100",
        "grade_num": "100/100",
        "comment": "",
        "prev": "",
        "docs": ""
      }
    ]
  });
}
