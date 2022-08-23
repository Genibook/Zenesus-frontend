import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";

class MPs {
  final List<dynamic> mps;
  final String mp;

  const MPs({
    required this.mps,
    required this.mp,
  });

  int length() {
    return mps.length;
  }

  factory MPs.fromJson(Map<String, dynamic> json) {
    return MPs(mps: json['mps'], mp: json['curr_mp']);
  }
}

Future<MPs> createMPs(String email, String password, String school) async {
  final response = await http.post(
    Uri.parse('${Constants.url}/api/availableMPs'),
    body: json.encode({
      'email': email,
      "password": password,
      'highschool': school,
    }),
  );

  if (response.statusCode == 200) {
    return MPs.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error');
  }
}

Future<MPs> modelMPs() async {
  await Future.delayed(const Duration(seconds: 2));
  return const MPs(mps: ['MP1', "MP2"], mp: "MP2");
}
