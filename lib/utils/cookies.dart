import 'package:shared_preferences/shared_preferences.dart';

Future<String> mpInCookies() async {
  late String mp;
  final prefs = await SharedPreferences.getInstance();
  mp = prefs.getString('mp') ?? "";
  return mp;
}

Future<void> writeMPintoCookies(String mp) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('mp', mp);
}
