import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/utils/api_utils.dart';

// ignore: camel_case_types
class Student_Name_and_ID {
  List<dynamic> names;
  List<dynamic> ids;

  Student_Name_and_ID({required this.names, required this.ids});

  factory Student_Name_and_ID.fromJson(Map<String, dynamic> json) {
    return Student_Name_and_ID(ids: json['ids'], names: json['names']);
  }
}

// ignore: non_constant_identifier_names
Future<Student_Name_and_ID> createStudent_name_and_ID(
    String email, String password, String school) async {
  int numm = await numInCookies();
  try {
    final response = await http.post(
      getCorrectUri("/api/studentNameandIds"),
      body: json.encode({
        'email': email,
        "password": password,
        'highschool': school,
        'user': numm
      }),
    );

    if (response.statusCode == 200) {
      //print(response.body);
      return Student_Name_and_ID.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error');
    }
  } catch (e) {
    //print(e);
    return Student_Name_and_ID.fromJson({
      "ids": ["N/A"],
      "names": ["N/A"]
    });
  }
}
