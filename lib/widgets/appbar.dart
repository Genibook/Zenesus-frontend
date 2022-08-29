import 'package:flutter/material.dart';
import 'package:zenesus/screens/firstscreen.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/screens/faq.dart';
import 'package:zenesus/widgets/simpledialogoption.dart';
import 'package:zenesus/serializers/students_name_and_id.dart';

class StudentAppBar extends StatelessWidget {
  const StudentAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: const Text(
        "Account",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        Tooltip(
          message: "Change User",
          child: IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () async {
              List<String> things = await readEmailPassSchoolintoCookies();
              String email = things[0];
              String password = things[1];
              String school = things[2];
              Student_Name_and_ID futureNameandID =
                  await createStudent_name_and_ID(email, password, school);
              await chooseUser(context, futureNameandID);
            },
          ),
        ),
        Tooltip(
          message: "FAQ page",
          child: IconButton(
            icon: const Icon(Icons.question_mark, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
        ),
        Tooltip(
            message: 'Log out',
            child: IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FirstScreen()),
                );
              },
            )),
      ],
    );
  }
}
