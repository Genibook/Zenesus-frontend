import 'package:flutter/material.dart';
import 'package:zenesus/screens/firstscreen.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/utils/appbar_utils.dart';
import 'package:zenesus/screens/faq.dart';
import 'package:zenesus/serializers/students_name_and_id.dart';
import 'package:vibration/vibration.dart';
import 'package:zenesus/screens/credits.dart';
import 'package:zenesus/utils/confetti.dart';

import 'package:confetti/confetti.dart';

class StudentAppBar extends StatefulWidget {
  const StudentAppBar({
    Key? key,
    required this.bday,
    required this.name,
  }) : super(key: key);

  final String bday;
  final String name;

  @override
  State<StatefulWidget> createState() => StudentAppBarState();
}

bool _ispressed = false;

class StudentAppBarState extends State<StudentAppBar> {
  bool _isbday = false;

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

  late ConfettiController _controller;
  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showStudents(Student_Name_and_ID futureNameandID) {
    showDialog<Student_Name_and_ID>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              backgroundColor: _isbday ? Colors.amberAccent[400] : null,
              title: const Text('Select Student'),
              children: createChildren(context, futureNameandID));
        });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _isbday = isBday(widget.bday);
    });

    return AppBar(
      backgroundColor: _isbday ? Colors.amber[700] : null,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: _isbday
          ? InkWell(
              child: Stack(children: [
                const Text(
                  "HBday!! 🎉🥚",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ConfettiWidget(
                    confettiController: _controller,
                    blastDirectionality: BlastDirectionality
                        .explosive, // don't specify a direction, blast randomly
                    shouldLoop:
                        false, // start again as soon as the animation is finished
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ], // manually specify the colors to be used
                    createParticlePath: drawStar, // define a custom shape/path.
                  ),
                )
              ]),
              onTap: () {
                _controller.play();
              },
            )
          : InkWell(
              child: const Text(
                "Account",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CreditsPage()));
              },
            ),
      actions: <Widget>[
        Tooltip(
          message: "Settings",
          child: _ispressed
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text("Loading...")])
              : IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
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

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor:
                                _isbday ? Colors.amberAccent[400] : null,
                            content: Container(
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            tileColor: _isbday
                                                ? Colors.amberAccent[400]
                                                : null,
                                            title: const Text("Change Student"),
                                            trailing: IconButton(
                                              icon: const Icon(
                                                Icons.person,
                                              ),
                                              onPressed: () =>
                                                  showStudents(futureNameandID),
                                            ),
                                            onTap: () {
                                              showStudents(futureNameandID);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                              tileColor: _isbday
                                                  ? Colors.amberAccent[400]
                                                  : null,
                                              title: const Text("Logout"),
                                              trailing: IconButton(
                                                icon: const Icon(
                                                  Icons.exit_to_app,
                                                ),
                                                onPressed: () {
                                                  logout();
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const FirstScreen()),
                                                  );
                                                },
                                              ),
                                              onTap: () {
                                                logout();
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const FirstScreen()),
                                                );
                                              }),
                                        ]))),
                          );
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
            icon: _isbday
                ? const Icon(Icons.cake, color: Colors.white)
                : const Icon(Icons.question_mark, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
        ),
      ],
    );
  }
}
