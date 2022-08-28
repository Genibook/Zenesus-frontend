import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";
import 'package:zenesus/utils/cookies.dart';

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
}

Future<Gpas> createGpas(String email, String password, String school) async {
  String mp = await mpInCookies();
  try {
    final response = await http.post(
      Uri.parse('${Constants.url}/api/gpas'),
      body: json.encode({
        'email': email,
        "password": password,
        'highschool': school,
        'mp': mp
      }),
    );

    if (response.statusCode == 200) {
      //print(response.body);
      return Gpas.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error');
    }
  } catch (e) {
    print(e);
    return Gpas.fromJson({});
  }
}
