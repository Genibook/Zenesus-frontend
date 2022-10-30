import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import "package:zenesus/constants.dart";
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/utils/store_objects.dart';

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

  Map<String, dynamic> toJson() {
    return {"mps": mps, "curr_mp": mp};
  }
}

Future<MPs> createMPs(
    String email, String password, String school, bool forceReload) async {
  int index = 4;
  Map<String, dynamic> cachedJson = await readObject(index);
  if (cachedJson.isNotEmpty && !forceReload) {
    if (await logicUpdateCache(DateTime.now()) || !forceReload) {
      MPs courses = MPs.fromJson(cachedJson);
      return courses;
    }
  }
  int numm = await numInCookies();
  try {
    final response = await http.post(
      Uri.parse('${Constants.url}/api/availableMPs'),
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
      MPs mps = MPs.fromJson(json);
      String mp = await mpInCookies();
      if (mp == "") {
        writeMPintoCookies(mps.mp);
      }

      return mps;
    } else {
      throw Exception('Error');
    }
  } catch (e) {
    return MPs.fromJson({
      'mps': ["MP1", "MP2"],
      'curr_mp': 'MP1'
    });
  }
}

Future<MPs> modelMPs() async {
  await Future.delayed(const Duration(seconds: 1));
  return const MPs(mps: ['MP1', "MP2"], mp: "MP2");
}
