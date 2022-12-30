// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenesus/constants.dart';
import 'package:zenesus/secrets.dart';

Future<void> writeBday(bool bday) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('bday', bday);
}

Future<bool> readBday() async {
  late bool bday;
  final prefs = await SharedPreferences.getInstance();
  bday = prefs.getBool('bday') ?? false;
  return bday;
}

Future<void> writeUserNumintoCookies(int numm) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('user', numm);
}

Future<int> numInCookies() async {
  late int numm;
  final prefs = await SharedPreferences.getInstance();
  numm = prefs.getInt('user') ?? 0;
  return numm;
}

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
      key: EMAILKEYY,
      value: email);
  await storage.write(
      key: PASSKEYY,
      value: password);
  await prefs.setString('school', school);
}

Future<List<String>> readEmailPassSchoolintoCookies() async {
  final prefs = await SharedPreferences.getInstance();
  const storage = FlutterSecureStorage();
  final String email = await storage.read(
          key: EMAILKEYY) ??
      "";
  final String password = await storage.read(
         key:PASSKEYY) ??
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

  bool acceptedPP = await readAcceptedPP();
  bool firstTime = await readFirstTime();
  // await prefs.remove('school');
  // await prefs.remove('mp');
  // await prefs.remove("user");
  // await prefs.remove('bday');

  // for (String name in names) {
  //   await prefs.remove(name);
  // }

  // await prefs.remove("lastCache");
  // await prefs.remove("todos");

  await prefs.clear();

  writeFirstTime(firstTime);
  writeAcceptedPP(acceptedPP);
}

Future<void> writeTodo(String todo) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> todos = prefs.getStringList(todosCookieName) ?? [];
  todos.add(todo);
  await prefs.setStringList(todosCookieName, todos);
}

Future<List<String>> readTodos() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(todosCookieName) ?? [];
}

Future<void> deleteTodo(int index) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> todos = prefs.getStringList(todosCookieName) ?? [];
  todos.removeAt(index);
  await prefs.setStringList(todosCookieName, todos);
}

Future<void> setTodo(List<String> todos) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(todosCookieName, todos);
}

Future<bool> readFirstTime() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(firstTimeName) ?? true;
}

Future<void> writeFirstTime(bool state) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(firstTimeName, state);
}

Future<void> updateTodoListVisiblity(bool status) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(todoListVisibilityCookieName, status);
}

Future<bool> readTodoListVisiblity() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(todoListVisibilityCookieName) ?? false;
}

Future<void> updateGradeProjectionsToggleCookie(bool status) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(gradeProjectToggleCookieName, status);
}

Future<bool> readGradeProjectionsToggle() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(gradeProjectToggleCookieName) ?? false;
}

Future<void> writeAcceptedPP(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(readPPCookieName, value);
}

Future<bool> readAcceptedPP() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(readPPCookieName) ?? false;
}
