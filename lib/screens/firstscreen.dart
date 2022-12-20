import 'package:flutter/material.dart';
import 'package:zenesus/screens/login.dart';
import 'package:zenesus/screens/welcomeScreenForFirstTimers.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/screens/coursespage.dart';

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
    List<String> things = await readEmailPassSchoolintoCookies();
    email = things[0];
    password = things[1];
    school = things[2];

    // remove data
    // final prefs = await SharedPreferences.getInstance();
    //
    // await prefs.remove('counter');

    if (email == "" || password == "" || school == "") {
      if (await readFirstTime()) {
        writeFirstTime();
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyLoginPage()),
         //MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyLoginPage()),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CoursesPage(
                  email: email,
                  password: password,
                  school: school,
                  refresh: false,
                )),
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
