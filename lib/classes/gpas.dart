import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/utils/store_objects.dart';
import 'package:zenesus/utils/api_utils.dart';

class Gpas {
  final double weightedGPA;
  final double unweightedGPA;

  const Gpas({required this.weightedGPA, required this.unweightedGPA});

  List<double> getGpas() {
    return [unweightedGPA, weightedGPA];
  }

  factory Gpas.fromJson(Map<String, dynamic> json) {
    return Gpas(
        weightedGPA: json['weighted gpa'],
        unweightedGPA: json['unweighted gpa']);
  }

  Map<String, dynamic> toJson() {
    return {
      "weighted gpa": weightedGPA,
      "unweighted gpa": unweightedGPA,
    };
  }
}

Future<Gpas> createGpas(
    String email, String password, String school, bool forceReload) async {
  int index = 5;
  Map<String, dynamic> cachedJson = await readObject(index);
  if (cachedJson.isNotEmpty && !forceReload) {
    if (await logicUpdateCache(
            DateTime.now(),
            BasicStudentInfo(
                email: email, password: password, school: school)) ||
        !forceReload) {
      Gpas courses = Gpas.fromJson(cachedJson);
      return courses;
    }
  }
  String mp = await mpInCookies();
  int numm = await numInCookies();
  try {
    final response = await http.post(
      getCorrectUri("/api/gpas"),
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
      //print(json);
      writeObject(json, index);
      return Gpas.fromJson(json);
    } else {
      throw Exception('Error');
    }
  } catch (e) {
    return Gpas.fromJson({"weighted gpa": 0.0, "unweighted gpa": 0.0});
  }
}

Future<Gpas> modelGpas() async {
  await Future.delayed(const Duration(seconds: 1));
  return Gpas.fromJson({"unweighted gpa": 100.0, "weighted gpa": 100.0});
}
