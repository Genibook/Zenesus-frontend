import 'package:flutter/material.dart';
import 'package:zenesus/widgets/appbar.dart';
import 'package:zenesus/serializers/student.dart';
import 'package:zenesus/icons/custom_icons_icons.dart';
import 'package:zenesus/screens/error.dart';
import 'package:zenesus/widgets/navbar.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _futureStudent =
          createStudent(widget.email, widget.password, widget.school);
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
          child = Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const StudentAppBar(),
            Expanded(
              flex: 3,
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[800]!, Colors.blueAccent],
                    ),
                  ),
                  child: Column(children: [
                    const Spacer(),
                    CircleAvatar(
                      radius: 65.0,
                      backgroundImage: NetworkImage(
                          snapshot.data!.img_url), //snapshot.data!.image_url
                      backgroundColor: Colors.white,
                    ),
                    const Spacer(),
                    Text(snapshot.data!.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800)),
                    const Spacer(),
                  ])),
            ),
            Expanded(
              flex: 5,
              child: Center(
                  child: Card(
                      child: SizedBox(
                          width: 310.0,
                          height: 280.0, //340 with bday
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.school,
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
                                        const Text(
                                          "Grade Level",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.grade,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey[400],
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.key,
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
                                        const Text(
                                          "Locker",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.locker,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey[400],
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      CustomIcons.id_badge,
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
                                        const Text(
                                          "Student ID",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.id,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey[400],
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.flag,
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
                                        const Text(
                                          "State ID",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.state_id,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey[400],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                // const SizedBox(
                                //   height: 20.0,
                                // ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     const Icon(
                                //       Icons.cake,
                                //       color: Colors.orangeAccent,
                                //       size: 35,
                                //     ),
                                //     const SizedBox(
                                //       width: 20.0,
                                //     ),
                                //     Column(
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.start,
                                //       children: [
                                //         const Text(
                                //           "Birthday",
                                //           style: TextStyle(
                                //             fontSize: 15.0,
                                //           ),
                                //         ),
                                //         Text(
                                //           snapshot.data!.birthday,
                                //           style: TextStyle(
                                //             fontSize: 12.0,
                                //             color: Colors.grey[400],
                                //           ),
                                //         )
                                //       ],
                                //     )
                                //   ],
                                // ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.calendar_month,
                                      color: Colors.purple,
                                      size: 35,
                                    ),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Schedule Link",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        InkWell(
                                          child: Text(
                                            "click me",
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          onTap: () {
                                            _launchUrl(
                                                snapshot.data!.schedule_link);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )))),
            )
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
            bottomNavigationBar: const Navbar(selectedIndex: 1), body: child);
      },
    );
  }
}
