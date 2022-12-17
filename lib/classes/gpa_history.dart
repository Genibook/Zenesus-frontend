import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/utils/store_objects.dart';
import 'package:zenesus/utils/api_utils.dart';

class GPAHistory {
  final String grade;
  final String schoolYear;
  final double unweightedGPA;
  final double weightedGPA;

  const GPAHistory(
      {required this.weightedGPA,
      required this.unweightedGPA,
      required this.grade,
      required this.schoolYear});

  factory GPAHistory.fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      return GPAHistory(
          weightedGPA: double.parse(json['weightedGPA']),
          unweightedGPA: double.parse(json['unweightedGPA']),
          schoolYear: json["schoolYear"],
          grade: json["grade"]);
    } else {
      return const GPAHistory(
          weightedGPA: 100,
          unweightedGPA: 100,
          grade: "N/A",
          schoolYear: "N/A");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "grade": grade,
      "schoolYear": schoolYear,
      "weightedGPA": weightedGPA,
      "unweightedGPA": unweightedGPA
    };
  }
}

class GPAHistorys {
  //TODO some people may not even have a year of this so it will be empty; i need to check if it is empty somewhere, then i won't display anything; i think an empty list in the seperated list builder would alr handle that if the list is empty which is good.

  final List<GPAHistory> datas;
  const GPAHistorys({required this.datas});

  factory GPAHistorys.fromJson(Map<String, dynamic> json) {
    List<GPAHistory> allItems = [];
    for (dynamic data in json["data"]) {
      allItems.add(GPAHistory.fromJson(data));
    }
    return GPAHistorys(datas: allItems);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> items = [];
    Map<String, dynamic> allItems = {};
    for (int i = 0; i < datas.length; i++) {
      items.add(jsonDecode(jsonEncode(datas[i])));
    }
    allItems["data"] = items;
    return allItems;
  }
}

Future<GPAHistorys> createHistoryGpas(
    String email, String password, String school, bool forceReload) async {
  int index = 6;
  Map<String, dynamic> cachedJson = await readObject(index);
  if (cachedJson.isNotEmpty && !forceReload) {
    if (await logicUpdateCache(
            DateTime.now(),
            BasicStudentInfo(
                email: email, password: password, school: school)) ||
        !forceReload) {
      GPAHistorys courses = GPAHistorys.fromJson(cachedJson);
      return courses;
    }
  }

  int numm = await numInCookies();
  try {
    final response = await http.post(
      getCorrectUri("/api/gradeHistory"),
      body: json.encode({
        'email': email,
        "password": password,
        'highschool': school,
        'user': numm
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      print(json);
      writeObject(json, index);
      return GPAHistorys.fromJson(json);
    } else {
      throw Exception('GPA history Error');
    }
  } catch (e) {
    //print(e);
    return GPAHistorys.fromJson({"data": []});
  }
}

Future<GPAHistorys> modelHistoryGpas() async {
  await Future.delayed(const Duration(seconds: 1));
  return GPAHistorys.fromJson({
    "data": [
      {
        "grade": "9",
        "schoolYear": "2021 - 22",
        "unweightedGPA": "100.0",
        "weightedGPA": "100.0"
      },
      {
        "grade": "8",
        "schoolYear": " 2020 - 21",
        "unweightedGPA": "94.75",
        "weightedGPA": "69.0"
      }
    ]
  });
}
