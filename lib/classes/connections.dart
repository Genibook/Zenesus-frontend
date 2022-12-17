import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";
import 'package:zenesus/utils/cookies.dart';

class LoginConnection {
  final int code;
  final String message;
  const LoginConnection({required this.code, required this.message});

  factory LoginConnection.fromJson(Map<String, dynamic> json) {
    return LoginConnection(code: json["code"], message: json['message']);
  }
}

Future<LoginConnection> checkLoginConnection(
    String email, String password, String school) async {

  int numm = await numInCookies();
  final response = await http.post(
    Uri.parse('${Constants.url}/api/loginConnection'),
    body: json.encode({
      'email': email,
      "password": password,
      'highschool': school,
      'user': numm
    }),
  );

  if (response.statusCode == 200) {
    //print(response.body);
    if (response.body.startsWith("<")) {
      //print(response.body);
      return const LoginConnection(code: 401, message: "error");
    }
    return LoginConnection.fromJson(jsonDecode(response.body));
  } else {
    
    print(Constants.url);
    print(response.statusCode);
    print(response.headers["location"] );
    throw Exception('Login Error');
  }
}
