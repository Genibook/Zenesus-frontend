import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenesus/screens/login.dart';
import 'package:zenesus/screens/studentpage.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Screen();
}

class Screen extends State<FirstScreen> {
  late String email;
  late String password;
  late String school;

  @override
  void initState() {
    super.initState();
  }

  void _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? "";
    password = prefs.getString('password') ?? "";
    school = prefs.getString('school') ?? "";

    // remove data
    // final prefs = await SharedPreferences.getInstance();
    //
    // await prefs.remove('counter');

    if (email == "" && password == "" && school == "") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MyLoginPage(
                  incorrect: false,
                )),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                StudentPage(email: email, password: password, school: school)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _getUserData();
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
          CircularProgressIndicator(),
          Text(
            "Please wait while we load your data",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
          )
        ])));
  }
}
