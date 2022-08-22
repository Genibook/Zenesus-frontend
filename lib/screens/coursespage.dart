import 'package:zenesus/serializers/courses.dart';
import 'package:zenesus/serializers/mps.dart';
import 'package:flutter/material.dart';
import 'package:zenesus/widgets/appbar.dart';
import 'dart:async';
import 'dart:math';
import 'package:zenesus/screens/coursedatapage.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/utils/utils.dart';

class GradesPage extends StatefulWidget {
  const GradesPage(
      {Key? key,
      required this.email,
      required this.password,
      required this.school})
      : super(key: key);
  final String email;
  final String password;
  final String school;

  @override
  State<StatefulWidget> createState() => GradePageState();
}

class GradePageState extends State<GradesPage> {
  Future<Courses>? _futureCourses;
  Future<MPs>? _futureMPs;
  late List<DropdownMenuItem<String>> _dropdownMenuMPS;
  late String _selectedMP;
  String? _mp;

  @override
  void initState() {
    super.initState();
    mpInCookies().then((String result) {
      setState(() {
        _mp = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _futureCourses = modelCourse();
      _futureMPs = modelMPs();

      //_futureCourses = createCourses(widget.email, widget.password, widget.school);
      //_futureMPs = createMPs(widget.email, widget.password, widget.school);
    });

    return buildFutureCourseBuilder(
        widget.email, widget.password, widget.school);
  }

  List<DropdownMenuItem<String>> buildDropdownMenuMPS(List<String> mps) {
    List<DropdownMenuItem<String>> items = [];
    for (String mp in mps) {
      items.add(
        DropdownMenuItem(
          value: mp,
          child: Text(mp),
        ),
      );
    }
    return items;
  }

  onChangeDropdownMP(String? selectedMP) {
    setState(() {
      _selectedMP = selectedMP!;
      writeMPintoCookies(selectedMP);
    });
  }

  String getMP(dynamic mp, dynamic snapshot) {
    if (mp == "") {
      writeMPintoCookies(snapshot.data!.mp);
      return snapshot.data!.mp;
    } else {
      return mp;
    }
  }

  FutureBuilder<MPs> buildFutureMPsBuilder() {
    return FutureBuilder(
      future: _futureMPs,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          _dropdownMenuMPS = buildDropdownMenuMPS(snapshot.data!.mps);
          _selectedMP = getMP(_mp, snapshot);
          FocusScope.of(context).unfocus();
          return Padding(
              padding: const EdgeInsets.all(0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month),
                    enabledBorder: InputBorder.none),
                value: _selectedMP,
                items: _dropdownMenuMPS,
                onChanged: onChangeDropdownMP,
                icon: const Visibility(
                    visible: false, child: Icon(Icons.arrow_downward)),
                isExpanded: false,
                autofocus: false,
              ));
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }

  FutureBuilder<Courses> buildFutureCourseBuilder(
      String email, String password, String highschool) {
    return FutureBuilder(
      future: _futureCourses,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          const double size = 200;
          const double twoPi = pi * 2;
          List<dynamic> data = snapshot.data!.courseGrades;
          List<double> averages =
              calculateGradeAverage(snapshot.data!.courseGrades);
          var brightness = MediaQuery.of(context).platformBrightness;
          bool isDarkMode = brightness == Brightness.dark;
          child = Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: size,
                        height: size,
                        child: Stack(children: [
                          ShaderMask(
                            shaderCallback: (rect) {
                              return SweepGradient(
                                  startAngle: 0,
                                  endAngle: twoPi,
                                  stops: [averages[1] / 100, averages[1] / 100],
                                  // 0.0, 0.5, 0.5, 1.0
                                  center: Alignment.center,
                                  colors: [
                                    getColorFromGrade(averages[1]),
                                    Colors.grey.withAlpha(55)
                                  ]).createShader(rect);
                            },
                            child: Container(
                              width: size,
                              height: size,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                            ),
                          ),
                          Center(
                            child: Container(
                              height: size - 40,
                              width: size - 40,
                              decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? const Color.fromARGB(255, 48, 48, 48)
                                      : Colors.white,
                                  shape: BoxShape.circle),
                              child: Center(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                    const Text("Weighted Average",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    Text("${roundDouble(averages[1], 2)}%",
                                        style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold))
                                  ])),
                            ),
                          )
                        ])),
                    const SizedBox(width: 20),
                    SizedBox(
                        width: size,
                        height: size,
                        child: Stack(children: [
                          ShaderMask(
                            shaderCallback: (rect) {
                              return SweepGradient(
                                  startAngle: 0,
                                  endAngle: twoPi,
                                  stops: [averages[0] / 100, averages[0] / 100],
                                  // 0.0, 0.5, 0.5, 1.0
                                  center: Alignment.center,
                                  colors: [
                                    getColorFromGrade(averages[0]),
                                    Colors.grey.withAlpha(55)
                                  ]).createShader(rect);
                            },
                            child: Container(
                              width: size,
                              height: size,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                            ),
                          ),
                          Center(
                            child: Container(
                              height: size - 40,
                              width: size - 40,
                              decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? const Color.fromARGB(255, 48, 48, 48)
                                      : Colors.white,
                                  shape: BoxShape.circle),
                              child: Center(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                    const Text("Unweighted Average",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    Text("${roundDouble(averages[0], 2)}%",
                                        style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold))
                                  ])),
                            ),
                          )
                        ])),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: buildFutureMPsBuilder(),
                ),
                ListView.separated(
                    separatorBuilder: (_, __) => const Divider(),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        // Course name
                        // teacher
                        // email
                        // grade
                        // not_graded
                        title: Text(
                          "${data[index][0]}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        subtitle: Text("${data[index][1]}\n${data[index][2]}"),
                        trailing: "${data[index][3]}" == "N/A"
                            ? Text(
                                "${data[index][3]}\n${data[index][4]}",
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blue),
                              )
                            : Text(
                                "${data[index][3]}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: getColorFromGrade(
                                        double.parse(data[index][3]))),
                              ),
                        enabled: true,
                        selected: false,

                        onTap: () {
                          late String mp;
                          mpInCookies().then(
                            (String value) {
                              setState(() {
                                mp = value;
                              });
                            },
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CourseDatasPage(
                                    email: email,
                                    password: password,
                                    school: highschool,
                                    courseName: "${data[index][0]}",
                                    mp: mp)),
                          );
                        },
                      );
                    }),
              ]);
          child = SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Padding(padding: const EdgeInsets.all(10), child: child));
        } else if (snapshot.hasError) {
          child = Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
        return Scaffold(body: child);
      },
    );
  }
}
