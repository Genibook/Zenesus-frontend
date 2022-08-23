import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

Future<void> writeEmailPassSchoolintoCookies(
    String email, String password, String school) async {
  final prefs = await SharedPreferences.getInstance();
  const storage = FlutterSecureStorage();
  await storage.write(key: dotenv.env['EMAILKEY'] ?? "", value: email);
  await storage.write(key: dotenv.env['PASSKEY'] ?? "", value: password);
  await prefs.setString('school', school);
}

Future<List<String>> readEmailPassSchoolintoCookies() async {
  final prefs = await SharedPreferences.getInstance();
  const storage = FlutterSecureStorage();
  final String email =
      await storage.read(key: dotenv.env['EMAILKEY'] ?? "") ?? "";
  final String password =
      await storage.read(key: dotenv.env['PASSKEY'] ?? "") ?? "";
  final school = prefs.getString('school') ?? "";
  return [email, password, school];
}
