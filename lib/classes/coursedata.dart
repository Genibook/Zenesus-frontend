import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/utils/store_objects.dart';

class CoursesData {
  final String mp;
  final String dayname;
  // ignore: non_constant_identifier_names
  final String full_dayname;
  final String date;
  // ignore: non_constant_identifier_names
  final String full_date;
  final dynamic teacher;
  final dynamic category;
  final dynamic assignment;
  final dynamic description;
  // ignore: non_constant_identifier_names
  final dynamic grade_percent;
  // ignore: non_constant_identifier_names
  final dynamic grade_num;
  final dynamic comment;
  final dynamic prev;
  final dynamic docs;
  // ignore: non_constant_identifier_names
  final String course_name;

  const CoursesData({
    // ignore: non_constant_identifier_names
    required this.course_name,
    required this.mp,
    required this.dayname,
    // ignore: non_constant_identifier_names
    required this.full_dayname,
    required this.date,
    // ignore: non_constant_identifier_names
    required this.full_date,
    required this.teacher,
    required this.category,
    required this.assignment,
    required this.description,
    // ignore: non_constant_identifier_names
    required this.grade_percent,
    // ignore: non_constant_identifier_names
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
        full_dayname: json['full_dayname'],
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

  Map<String, dynamic> toJson() {
    return {
      "course_name": course_name,
      "mp": mp,
      "dayname": dayname,
      "full_dayname": full_dayname,
      "date": date,
      "full_date": full_date,
      "teacher": teacher,
      "category": category,
      "assignment": assignment,
      "description": description,
      "grade_percent": grade_percent,
      "grade_num": grade_num,
      "comment": comment,
      "prev": prev,
      "docs": docs
    };
  }
}

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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    List<Map<String, dynamic>> items = [];
    Map<String, dynamic> allItems = {};
    //List<CoursesData> data in datas
    for (int i = 0; i < datas.length; i++) {
      List<CoursesData> data = datas[i];
      for (CoursesData smolData in data) {
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

Future<CoursesDatas> createCoursesDatas(String email, String password,
    String school, String mp, bool forceReload) async {
  int index = 1;
  Map<String, dynamic> cachedJson = await readObject(index);

  if (cachedJson.isNotEmpty && !forceReload) {
    if (await logicUpdateCache(
            DateTime.now(),
            BasicStudentInfo(
                email: email, password: password, school: school)) ||
        !forceReload) {
      CoursesDatas courses = CoursesDatas.fromJson(cachedJson);
      return courses;
    }
  }

  int numm = await numInCookies();
  try {
    final response = await http.post(
      Uri.parse('${Constants.url}/api/courseinfos'),
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
      return CoursesDatas.fromJson(json);
    } else {
      throw Exception('Error');
    }
  } catch (e) {
    //print(e);
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
        "course_name": "AP Chemistry",
        "mp": "MP2",
        "dayname": "Mon",
        "full_dayname": "Monday",
        "date": "6/7",
        "full_date": "6/7/2022",
        "teacher": "Ms.Applegate",
        "category": "Summative",
        "assignment": "Unit 10 Test",
        "description": "daSFASDF",
        "grade_percent": "100",
        "grade_num": "100/100",
        "comment": "you did well eddie :D",
        "prev": "asdfdasf",
        "docs": "asdfasdf"
      },
      {
        "course_name": "AP Chemistry",
        "mp": "MP2",
        "dayname": "Mon",
        "full_dayname": "Monday",
        "date": "5/7",
        "full_date": "5/7/2022",
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
        "course_name": "AP Chemistry",
        "mp": "MP2",
        "dayname": "Mon",
        "full_dayname": "Monday",
        "date": "4/7",
        "full_date": "4/7/2022",
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
        "course_name": "AP Chemistry",
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
        "course_name": "AP Chemistry",
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
        "course_name": "AP Chemistry",
        "mp": "MP2",
        "dayname": "Mon",
        "full_dayname": "Monday",
        "date": "6/7",
        "full_date": "6/7/2022",
        "teacher": "Ms.Applegate",
        "category": "Summative",
        "assignment": "Unit 69 Test",
        "description": "heheehawhaw",
        "grade_percent": "69",
        "grade_num": "100/100",
        "comment": "",
        "prev": "",
        "docs": ""
      }
    ]
  });
}
