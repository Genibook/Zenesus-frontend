import 'package:flutter/material.dart';
import 'package:zenesus/constants.dart';
import 'package:zenesus/utils/base64.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/widgets/appbar.dart';
import 'package:zenesus/classes/student.dart';
import 'package:zenesus/icons/custom_icons_icons.dart';
import 'package:zenesus/screens/error.dart';
import 'package:zenesus/widgets/navbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenesus/utils/appbar_utils.dart';
import 'package:zenesus/utils/confetti.dart';
import 'package:confetti/confetti.dart';

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}

class StudentPage extends StatefulWidget {
  const StudentPage(
      {Key? key,
      required this.email,
      required this.password,
      required this.school})
      : super(key: key);
  final String email;
  final String password;
  final String school;

  @override
  State<StatefulWidget> createState() => Courses();
}

class Courses extends State<StudentPage> {
  Future<Student>? _futureStudent;
  int _hoverCounts = 0;
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 16));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _futureStudent =
          createStudent(widget.email, widget.password, widget.school, false);
      //_futureStudent = modelStudent();
    });

    return buildFutureBuilder();
  }

  FutureBuilder<Student> buildFutureBuilder() {
    return FutureBuilder(
      future: _futureStudent,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          bool isbday = isBday(snapshot.data!.birthday);
          writeBday(false);
          child = Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            StudentAppBar(
                bday: snapshot.data!.birthday, name: snapshot.data!.name),
            Expanded(
              flex: 3,
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[800]!, Colors.blueAccent],
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        isbday
                            ? CircleAvatar(
                                radius: 65.0,
                                backgroundImage:
                                    createImageFromImage64(snapshot),

                                // NetworkImage()//snapshot.data!.image_url
                                backgroundColor:
                                    isbday ? Colors.grey[200] : Colors.white,
                              )
                            : MouseRegion(
                                onEnter: (event) {
                                  _hoverCounts++;
                                  if (_hoverCounts == 20) {
                                    _controller.play();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const AlertDialog(
                                            title: Text(
                                                "Congratulations! You found an easter egg!"),
                                          );
                                        });
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 65.0,
                                  backgroundImage:
                                      createImageFromImage64(snapshot),
                                  // NetworkImage()//snapshot.data!.image_url
                                  backgroundColor:
                                      isbday ? Colors.grey[200] : Colors.white,
                                ),
                              ),
                        const Spacer(),
                        Text(snapshot.data!.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Align(
                          alignment: Alignment.center,
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
                            createParticlePath:
                                drawStar, // define a custom shape/path.
                          ),
                        )
                      ])),
            ),
            Expanded(
                flex: 5,
                child: Container(
                  color: isbday ? Colors.amber[600] : null,
                  child: Center(
                      child: Card(
                          color: isbday ? Colors.amber : null,
                          child: SizedBox(
                              width: 310.0,
                              height: 290.0, //340 with bday
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.blueAccent[400],
                                          size: 35,
                                        ),
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              child: Text(
                                                "Schedule",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: isbday
                                                        ? Colors.white
                                                        : null),
                                              ),
                                              onTap: () {},
                                            ),
                                            InkWell(
                                              child: Text(
                                                "click me",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: isbday
                                                      ? Colors.grey[100]
                                                      : Colors.grey[400],
                                                ),
                                              ),
                                              onTap: () {
                                                _launchUrl(snapshot
                                                    .data!.schedule_link);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.school,
                                          color: Colors.yellowAccent[400],
                                          size: 35,
                                        ),
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Grade Level",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: isbday
                                                      ? Colors.white
                                                      : null),
                                            ),
                                            Text(
                                              snapshot.data!.grade,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: isbday
                                                    ? Colors.grey[100]
                                                    : Colors.grey[400],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.key,
                                          color: Colors.pinkAccent[400],
                                          size: 35,
                                        ),
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Locker",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: isbday
                                                      ? Colors.white
                                                      : null),
                                            ),
                                            Text(
                                              snapshot.data!.locker,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: isbday
                                                    ? Colors.grey[100]
                                                    : Colors.grey[400],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          CustomIcons.idBadge,
                                          color: Colors.lightGreen[400],
                                          size: 35,
                                        ),
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Student ID",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: isbday
                                                      ? Colors.white
                                                      : null),
                                            ),
                                            Text(
                                              snapshot.data!.id,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: isbday
                                                    ? Colors.grey[100]
                                                    : Colors.grey[400],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.flag,
                                          color: Colors.purple[700],
                                          size: 35,
                                        ),
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "State ID",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: isbday
                                                      ? Colors.white
                                                      : null),
                                            ),
                                            Text(
                                              snapshot.data!.state_id,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: isbday
                                                    ? Colors.grey[100]
                                                    : Colors.grey[400],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )))),
                ))
          ]);
          if (snapshot.data!.name == "N/A" &&
              snapshot.data!.counselor_name == "N/A") {
            child = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Center(child: createErrorPage(context))]);
          }
        } else if (snapshot.hasError) {
          child = Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ]));
        } else {
          child = Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Fetching your information...'),
                )
              ]));
        }
        return Scaffold(
            bottomNavigationBar: Navbar(
              selectedIndex: profileNavNum,
            ),
            body: child);
      },
    );
  }
}
