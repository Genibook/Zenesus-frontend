import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";
import 'package:zenesus/utils/cookies.dart';
import "package:zenesus/utils/base64.dart";
import 'package:zenesus/utils/store_objects.dart';

class Student {
  // ignore: non_constant_identifier_names
  final String img_url;
  final String id;
  // ignore: non_constant_identifier_names
  final String state_id;
  final String birthday;
  // ignore: non_constant_identifier_names
  final String schedule_link;
  final String name;
  final String grade;
  final String locker;
  final String age;
  // ignore: non_constant_identifier_names
  final String counselor_name;
  final String image64;

  const Student(
      // ignore: non_constant_identifier_names
      {required this.img_url,
      required this.id,
      // ignore: non_constant_identifier_names
      required this.state_id,
      required this.age,
      required this.birthday,
      // ignore: non_constant_identifier_names
      required this.counselor_name,
      required this.grade,
      required this.locker,
      required this.name,
      // ignore: non_constant_identifier_names
      required this.schedule_link,
      required this.image64});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        img_url: json['img_url'],
        id: json['student_id'],
        state_id: json["state_id"],
        schedule_link: json["schedule_link"],
        birthday: json['birthday'],
        age: json['age'],
        counselor_name: json['counselor_name'],
        locker: json['locker'],
        grade: json["grade"],
        name: json['name'],
        image64: json['image64']);
  }

  Map<String, dynamic> toJson() {
    return {
      "age": age,
      "img_url": img_url,
      "state_id": state_id,
      "birthday": birthday,
      "schedule_link": schedule_link,
      "name": name,
      "grade": grade,
      "locker": locker,
      "counselor_name": counselor_name,
      "id": id,
      "image64": image64,
    };
  }
}

Future<Student> createStudent(
    String email, String password, String school, bool forceReload) async {
  int index = 3;
  Map<String, dynamic> cachedJson = await readObject(index);
  if (cachedJson.isNotEmpty &&
      (!forceReload || await logicUpdateCache(DateTime.now()))) {
    Student courses = Student.fromJson(cachedJson);
    return courses;
  }
  int numm = await numInCookies();
  try {
    final response = await http.post(
      Uri.parse('${Constants.url}/api/login'),
      body: json.encode({
        'email': email,
        "password": password,
        'highschool': school,
        'user': numm
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      writeObject(json, index);
      return Student.fromJson(json);
    } else {
      throw Exception('creating student error');
    }
  } catch (e) {
    print(e);
    return const Student(
        age: "15",
        img_url: "N/A",
        state_id: "12312312",
        birthday: "N/A",
        schedule_link: "N/A",
        name: "N/A",
        grade: "10",
        locker: "123 123-123-123",
        counselor_name: "N/A",
        id: "107600",
        image64: "N/A");
  }
}

Future<Student> modelStudent() async {
  await Future.delayed(const Duration(seconds: 1));
  return const Student(
      age: "15",
      img_url: "https://c.tenor.com/bCfpwMjfAi0AAAAC/cat-typing.gif",
      state_id: "12312312",
      birthday: "06-07-2007",
      schedule_link: "https://example.com",
      name: "Eddie Tang",
      grade: "10",
      locker: "123 123-123-123",
      counselor_name: "Mathew Pogue",
      id: "107600",
      image64: "N/A");
}
