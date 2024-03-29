import 'package:flutter/material.dart';
import 'package:zenesus/utils/appbar_utils.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/screens/faq.dart';
import 'package:zenesus/classes/students_name_and_id.dart';
import 'package:zenesus/screens/credits.dart';
import 'package:zenesus/utils/confetti.dart';
import 'package:zenesus/widgets/settings.dart';

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

// confetti controller for confetti when bday
  late ConfettiController _controller;
  @override
  void initState() {
    super.initState();
    // init the controller
    _controller = ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  void dispose() {
    //dispose it :D
    _controller.dispose();
    super.dispose();
  }

  // show available students using a dialog

  @override
  Widget build(BuildContext context) {
    setState(() {
      // get if it is the bday of person
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

      // right side actions icon buttons
      actions: <Widget>[
        Tooltip(
          message: "Settings",
          child: _ispressed
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text("Loading...")])
              : IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () async {
                    setState(() {
                      _ispressed = true;
                    });

                    // get the email password and username
                    List<String> things =
                        await readEmailPassSchoolintoCookies();
                    String email = things[0];
                    String password = things[1];
                    String school = things[2];

                    // create the object with api call
                    Student_Name_and_ID futureNameandID =
                        await createStudent_name_and_ID(
                            email, password, school);

                    //show the settings dialog
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Settings(
                              isBday: _isbday,
                              futureNameandID: futureNameandID);
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
                ? const Icon(Icons.cake)
                : const Icon(Icons.question_mark),
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
