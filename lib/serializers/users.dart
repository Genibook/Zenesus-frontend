import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";

class Users {
  final int numUsers;
  const Users({
    required this.numUsers,
  });
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(numUsers: json['users']);
  }
}

Future<Users> createUsers(String email, String password, String school) async {
  try {
    final response = await http.post(
      Uri.parse('${Constants.url}/api/getusers'),
      body: json.encode({
        'email': email,
        "password": password,
        'highschool': school,
      }),
    );
    if (response.statusCode == 200) {
      return Users.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error');
    }
  } catch (e) {
    //print(e);
    return Users.fromJson({'users': "0"});
  }
}
