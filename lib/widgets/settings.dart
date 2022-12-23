import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zenesus/classes/students_name_and_id.dart';
import 'package:zenesus/constants.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/screens/coursespage.dart';
import 'package:zenesus/screens/firstscreen.dart';
import 'package:zenesus/widgets/qaitem.dart';
import 'package:universal_platform/universal_platform.dart';
import 'dart:async';

class Settings extends StatefulWidget {
  const Settings({
    Key? key,
    required this.isBday,
    required this.futureNameandID,
  }) : super(key: key);

  final bool isBday;
  final Student_Name_and_ID futureNameandID;

  @override
  State<StatefulWidget> createState() => SettingState();
}

class SettingState extends State<Settings> {
  Future<bool>? _todoListVis;
  Future<bool>? _gradeProjectToggle;

  @override
  void initState() {
    super.initState();
  }

  void updateToggle(bool value, String name) {
    // setState(() => _todoListVis = value);
    if (name == todoListVisibilityCookieName) {
      setState(() {
        _todoListVis = Future.value(value);
        updateTodoListVisiblity(value);
      });

      //means todo list show
      if (value) {
        setState(() {
          gradesNavNum = hasTodoListGradesNavNum;
          profileNavNum = hasTodoListProfileNavNum;
          scheduleNavNum = hasTodoListScheduleNavNum;
          todoNavNum = hasTodoListTodoNavNum;
        });
      } else {
        setState(() {
          gradesNavNum = noTodoListGradesNavNum;
          profileNavNum = noTodoListProfileNavNum;
          scheduleNavNum = noTodoListScheduleNavNum;
        });
      }
    } else if (name == gradeProjectToggleCookieName) {
      setState(() {
        _gradeProjectToggle = Future.value(value);
        updateGradeProjectionsToggleCookie(value);
      });
    }
    // readEmailPassSchoolintoCookies().then((value) {
    //   List<String> things = value;
    //   String email = things[0];
    //   String password = things[1];
    //   String school = things[2];
    //   // Navigator.pop(context);
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => CoursesPage(
    //               email: email,
    //               password: password,
    //               school: school,
    //               refresh: false,
    //             )),
    //   );
    // });
  }

  // store cookies, and return pass, school and cookies
  Future<List<String>> onPressedDoStuff(int i) async {
    await writeUserNumintoCookies(i);
    List<String> things = await readEmailPassSchoolintoCookies();
    String email = things[0];
    String password = things[1];
    String school = things[2];
    return [email, password, school];
  }

  FutureBuilder<bool> buildTodoListToggleFutureBuilder() {
    return FutureBuilder(
        future: _todoListVis,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return (UniversalPlatform.isIOS ||
                    UniversalPlatform.isMacOS ||
                    UniversalPlatform.isLinux)
                ? CupertinoSwitch(
                    activeColor: primaryColor,
                    value: snapshot.data!,
                    // changes the state of the switch
                    onChanged: (value) {
                      updateToggle(value, todoListVisibilityCookieName);
                    },
                  )
                : Switch(
                    // thumb color (round icon)
                    activeColor: primaryColor,
                    value: snapshot.data!,
                    // changes the state of the switch
                    onChanged: (value) {
                      updateToggle(value, todoListVisibilityCookieName);
                    },
                  );
          } else {
            return const SizedBox();
          }
        }));
  }

  FutureBuilder<bool> buildGradeProjToggleFutureBuilder() {
    return FutureBuilder(
        future: _gradeProjectToggle,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return (UniversalPlatform.isIOS ||
                    UniversalPlatform.isMacOS ||
                    UniversalPlatform.isLinux)
                ? CupertinoSwitch(
                    activeColor: primaryColor,
                    value: snapshot.data!,
                    // changes the state of the switch
                    onChanged: (value) {
                      updateToggle(value, gradeProjectToggleCookieName);
                    },
                  )
                : Switch(
                    // thumb color (round icon)
                    activeColor: primaryColor,
                    value: snapshot.data!,
                    // changes the state of the switch
                    onChanged: (value) {
                      updateToggle(value, gradeProjectToggleCookieName);
                    },
                  );
          } else {
            return const SizedBox();
          }
        }));
  }

  //genearte list of children for experimental features
  List<Widget> createExperimentalChildren() {
    List<Widget> myList = [
      ListTile(
        tileColor: widget.isBday ? bdayColor : null,
        title: const Text("Todo-list"),
        // onTap: (() {}),
        trailing: buildTodoListToggleFutureBuilder(),
      ),
      ListTile(
        tileColor: widget.isBday ? bdayColor : null,
        title: const Text("Grade Projections"),
        // onTap: (() {}),
        trailing: buildGradeProjToggleFutureBuilder(),
      ),
    ];
    return myList;
  }

  // create the list of children for the dialog that shows the student name and ids.
  List<Widget> createChildren(BuildContext context, Student_Name_and_ID data) {
    List<Widget> myList = [];
    for (int i = 0; i < data.ids.length; i++) {
      myList.add(
        SimpleDialogOption(
          onPressed: () {
            onPressedDoStuff(i).then((List<String> value) {
              //Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CoursesPage(
                          email: value[0],
                          password: value[1],
                          school: value[2],
                          refresh: true,
                        )),
              );
            });
          },
          child: Text('${data.names[i]} - ${data.ids[i]}'),
        ),
      );
    }
    return myList;
  }

  void showStudents(Student_Name_and_ID futureNameandID) {
    showDialog<Student_Name_and_ID>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              backgroundColor: widget.isBday ? bdayColor : null,
              title: const Text('Select Student'),
              children: createChildren(context, futureNameandID));
        });
  }

  @override
  Widget build(BuildContext context) {
    _todoListVis = readTodoListVisiblity();
    _gradeProjectToggle = readGradeProjectionsToggle();
    return AlertDialog(
        backgroundColor: widget.isBday ? bdayColor : null,
        content: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //exp items
                  QAItem(
                      color: widget.isBday ? bdayColor : null,
                      title: const Text(
                        "Experimental Features",
                      ),
                      children: createExperimentalChildren()),

                  // students tile
                  ListTile(
                    tileColor: widget.isBday ? bdayColor : null,
                    title: const Text("Change Student"),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.person,
                      ),
                      onPressed: () => showStudents(widget.futureNameandID),
                    ),
                    onTap: () {
                      showStudents(widget.futureNameandID);
                    },
                  ),

                  // logout listtile
                  ListTile(
                      tileColor: widget.isBday ? bdayColor : null,
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
                                builder: (context) => const FirstScreen()),
                          );
                        },
                      ),
                      onTap: () {
                        logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FirstScreen()),
                        );
                      }),
                ])));
  }
}
