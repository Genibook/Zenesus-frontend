import 'package:flutter/material.dart';
import 'package:zenesus/screens/firstscreen.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/screens/faq.dart';
import 'package:zenesus/serializers/students_name_and_id.dart';
import 'package:vibration/vibration.dart';

class StudentAppBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StudentAppBarState();
}

class StudentAppBarState extends State<StudentAppBar> {
  int randomNum = 0;
  List<Widget> createChildren(BuildContext context, Student_Name_and_ID data) {
    List<Widget> myList = [];
    for (int i = 0; i < data.ids.length; i++) {
      myList.add(
        SimpleDialogOption(
          onPressed: () async {
            setState(() {
              randomNum = i;
            });
            await writeUserNumintoCookies(i);
            if (await Vibration.hasVibrator() ?? false) {
              Vibration.vibrate();
            }
            return;
          },
          child: Text('${data.names[i]} - ${data.ids[i]}'),
        ),
      );
    }
    return myList;
  }

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

              await showDialog<Student_Name_and_ID>(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                        title: const Text('Select Student'),
                        children: createChildren(context, futureNameandID));
                  });
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
