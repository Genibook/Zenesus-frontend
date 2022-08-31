import 'package:flutter/material.dart';
import 'package:zenesus/screens/firstscreen.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/screens/faq.dart';
import 'package:zenesus/serializers/students_name_and_id.dart';
import 'package:vibration/vibration.dart';
import 'package:zenesus/screens/credits.dart';

class StudentAppBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StudentAppBarState();
}

bool _ispressed = false;

class StudentAppBarState extends State<StudentAppBar> {
  Future<List<String>> onPressedDoStuff(int i) async {
    await writeUserNumintoCookies(i);
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate();
    }
    List<String> things = await readEmailPassSchoolintoCookies();
    String email = things[0];
    String password = things[1];
    String school = things[2];
    return [email, password, school];
  }

  List<Widget> createChildren(BuildContext context, Student_Name_and_ID data) {
    List<Widget> myList = [];
    for (int i = 0; i < data.ids.length; i++) {
      myList.add(
        SimpleDialogOption(
          onPressed: () {
            onPressedDoStuff(i).then((value) {
              Navigator.of(context).pop();
              const snackBar = SnackBar(
                content: Text(
                    "Success!😁 - go to grades and you will now see the other user's grades!"),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
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
      title: InkWell(
        child: const Text(
          "Account",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CreditsPage()));
        },
      ),
      actions: <Widget>[
        Tooltip(
          message: "Change User",
          child: _ispressed
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text("Loading...")])
              : IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () async {
                    setState(() {
                      _ispressed = true;
                    });

                    List<String> things =
                        await readEmailPassSchoolintoCookies();
                    String email = things[0];
                    String password = things[1];
                    String school = things[2];
                    Student_Name_and_ID futureNameandID =
                        await createStudent_name_and_ID(
                            email, password, school);

                    showDialog<Student_Name_and_ID>(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                              title: const Text('Select Student'),
                              children:
                                  createChildren(context, futureNameandID));
                        });
                    setState(() {
                      _ispressed = false;
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
