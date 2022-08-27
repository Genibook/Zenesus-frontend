// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<String> mpInCookies() async {
  late String mp;
  final prefs = await SharedPreferences.getInstance();
  mp = prefs.getString('mp') ?? "";
  return mp;
}

String getMP(dynamic mp, dynamic snapshot) {
  if (mp == "") {
    writeMPintoCookies(snapshot.data!.mp);
    return snapshot.data!.mp;
  } else {
    return mp;
  }
}

Future<void> writeMPintoCookies(String mp) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('mp', mp);
}

Future<void> writeEmailPassSchoolintoCookies(
    String email, String password, String school) async {
  final prefs = await SharedPreferences.getInstance();
  const storage = FlutterSecureStorage();
  await storage.write(
      key: const String.fromEnvironment('EMAILKEY', defaultValue: ''),
      value: email);
  await storage.write(
      key: const String.fromEnvironment('PASSKEY', defaultValue: ''),
      value: password);
  await prefs.setString('school', school);
}

Future<List<String>> readEmailPassSchoolintoCookies() async {
  final prefs = await SharedPreferences.getInstance();
  const storage = FlutterSecureStorage();
  final String email = await storage.read(
          key: const String.fromEnvironment('EMAILKEY', defaultValue: '')) ??
      "";
  final String password = await storage.read(
          key: const String.fromEnvironment('PASSKEY', defaultValue: '')) ??
      "";
  final school = prefs.getString('school') ?? "";
  return [email, password, school];
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  const storage = FlutterSecureStorage();
  await storage.delete(
      key: const String.fromEnvironment('EMAILKEY', defaultValue: ''));
  await storage.delete(
      key: const String.fromEnvironment('PASSKEY', defaultValue: ''));
  await prefs.remove('school');
  await prefs.remove('mp');
}
