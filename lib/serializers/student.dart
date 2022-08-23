import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";

class Student {
  final String img_url;
  final int id;
  final int state_id;
  final String birthday;
  final String schedule_link;
  final String name;
  final int grade;
  final String locker;
  final int age;
  final String counselor_name;

  const Student(
      {required this.img_url,
      required this.id,
      required this.state_id,
      required this.age,
      required this.birthday,
      required this.counselor_name,
      required this.grade,
      required this.locker,
      required this.name,
      required this.schedule_link});

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
        name: json['name']);
  }
}

Future<Student> createStudent(
    String email, String password, String school) async {
  try {
    final response = await http.post(
      Uri.parse('${Constants.url}/api/login'),
      body: json.encode({
        'email': email,
        "password": password,
        'highschool': school,
      }),
    );
    if (response.statusCode == 200) {
      return Student.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error');
    }
  } catch (e) {
    print(e);
    return const Student(
        age: 15,
        img_url: "N/A",
        state_id: 12312312,
        birthday: "N/A",
        schedule_link: "N/A",
        name: "N/A",
        grade: 10,
        locker: "123 123-123-123",
        counselor_name: "N/A",
        id: 107600);
  }
}

Future<Student> modelStudent() async {
  await Future.delayed(const Duration(seconds: 1));
  return const Student(
      age: 15,
      img_url: "https://example.com",
      state_id: 12312312,
      birthday: "06-07-2007",
      schedule_link: "https://example.com",
      name: "Eddie Tang",
      grade: 10,
      locker: "123 123-123-123",
      counselor_name: "Mathew Pogue",
      id: 107600);
}
