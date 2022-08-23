import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";

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
  final response = await http.post(
    Uri.parse('${Constants.url}/api/loginConnection'),
    body: json.encode({
      'email': email,
      "password": password,
      'highschool': school,
    }),
  );

  if (response.statusCode == 200) {
    return LoginConnection.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error');
  }
}
