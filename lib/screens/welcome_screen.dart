import 'package:flutter/material.dart';
import 'package:zenesus/constants.dart';
import 'package:zenesus/utils/api_utils.dart';
import 'package:zenesus/screens/coursespage.dart';
import 'package:zenesus/screens/login.dart';
import 'package:zenesus/utils/cookies.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen(
      {Key? key,
      required this.email,
      required this.password,
      required this.school})
      : super(key: key);

  final String email;
  final String password;
  final String school;
  @override
  State<StatefulWidget> createState() => WelcomeScreenState();
}

//lets do some animation shit here...

class WelcomeScreenState extends State<WelcomeScreen> {
  bool clickedPrivacyPolicy = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            centerTitle: true,
            title: const Text("Welcome!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          ),
          const Text(
            "Looks like this is your first time using Zenesus!",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          InkWell(
            child: const Text("Please Read Our Privacy Policy!",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                )),
            onTap: () {
              setState(() {
                clickedPrivacyPolicy = true;
              });
              llaunchUrl(PRIVACY_POLICY_LINK);
            },
          ),
          //const Text("Please Read Our Privacy Policy!"),
          const SizedBox(height: 20),
          clickedPrivacyPolicy
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          writeAcceptedPP(true);
                          writeFirstTime(false);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CoursesPage(
                                      email: widget.email,
                                      password: widget.password,
                                      school: widget.school,
                                      refresh: true,
                                    )),
                          );
                        },
                        child: const Text("I Agree",
                            style: TextStyle(fontSize: 20))),
                    ElevatedButton(
                        onPressed: () {
                          writeAcceptedPP(false);
                          writeFirstTime(true);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyLoginPage()),
                          );
                        },
                        child: const Text("I Disagree",
                            style: TextStyle(fontSize: 20))),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
