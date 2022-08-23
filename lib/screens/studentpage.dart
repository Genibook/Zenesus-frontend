import 'package:flutter/material.dart';
import 'package:zenesus/widgets/appbar.dart';
import 'package:zenesus/serializers/student.dart';
import 'package:zenesus/icons/custom_icons_icons.dart';
import 'package:zenesus/screens/error.dart';

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
  State<StatefulWidget> createState() => _courses();
}

class _courses extends State<StudentPage> {
  Future<Student>? _futureStudent;

  @override
  void initState() {
    super.initState();
    final String email = widget.email;
    final String password = widget.password;
    final String school = widget.school;
    setState(() {
      _futureStudent = createStudent(email, password, school);
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilder();
  }

  FutureBuilder<Student> buildFutureBuilder() {
    return FutureBuilder(
      future: _futureStudent,
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          children = <Widget>[
            const StudentAppBar(),
            Expanded(
              flex: 4,
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[800]!, Colors.blueAccent],
                    ),
                  ),
                  child: Column(children: [
                    const Spacer(),
                    const CircleAvatar(
                      radius: 65.0,
                      backgroundImage: AssetImage(
                          'assets/user.png'), //snapshot.data!.image_url
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
                          height: 280.0,
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
                                          snapshot.data!.grade.toString(),
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
                                          snapshot.data!.id.toString(),
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
                                          snapshot.data!.state_id.toString(),
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
                                    const Icon(
                                      Icons.cake,
                                      color: Colors.orangeAccent,
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
                                          "Birthday",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.birthday,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey[400],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )))),
            ),
          ];
          if (snapshot.data!.name == "N/A" &&
              snapshot.data!.counselor_name == "N/A") {
            children = [createErrorPage(context)];
          }
        } else if (snapshot.hasError) {
          children = <Widget>[
            const StudentAppBar(),
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ];
        } else {
          children = const <Widget>[
            StudentAppBar(),
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Fetching your information...'),
            )
          ];
        }
        return Scaffold(
            body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        ));
      },
    );
  }
}
