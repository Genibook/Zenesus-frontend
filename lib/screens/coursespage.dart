import 'dart:ui';

import 'package:zenesus/classes/courses.dart';
import 'package:zenesus/classes/mps.dart';
import 'package:zenesus/classes/gpas.dart';
import 'package:zenesus/classes/coursedata.dart';
import 'package:zenesus/classes/schedules.dart';
import 'package:zenesus/classes/student.dart';

import 'package:flutter/material.dart';
import 'package:zenesus/constants.dart';
import 'package:zenesus/utils/api_utils.dart';
import 'package:zenesus/widgets/gpa_circles.dart';
import 'dart:async';
import 'package:zenesus/screens/coursedatapage.dart';
import 'package:zenesus/screens/error.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/utils/gpa_utils.dart';
import 'package:zenesus/widgets/navbar.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage(
      {Key? key,
      required this.email,
      required this.password,
      required this.school,
      required this.refresh})
      : super(key: key);
  final String email;
  final String password;
  final String school;
  final bool refresh;

  @override
  State<StatefulWidget> createState() => GradePageState();
}

class GradePageState extends State<CoursesPage> {
  Future<Courses>? _futureCourses;
  Future<MPs>? _futureMPs;
  Future<Gpas>? _futureGpas;
  late List<DropdownMenuItem<String>> _dropdownMenuMPS;
  late String _selectedMP;
  String? _mp;
  bool mpsLoading = false;

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
      if (TEST_DATA) {
        _futureCourses = modelCourse();
        _futureMPs = modelMPs();
        _futureGpas = modelGpas();
      } else {
        _futureMPs = createMPs(
            widget.email, widget.password, widget.school, widget.refresh);
        _futureGpas = createGpas(
            widget.email, widget.password, widget.school, widget.refresh);

        _futureCourses = createCourses(
            widget.email, widget.password, widget.school, widget.refresh);
      }
    });

    return buildFutureCourseBuilder(
        widget.email, widget.password, widget.school);
  }

  List<DropdownMenuItem<String>> buildDropdownMenuMPS(List<dynamic> mps) {
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

  onChangeDropdownMP(String? selectedMP) async {
    setState(() {
      _selectedMP = selectedMP!;
      mpsLoading = true;
      writeMPintoCookies(selectedMP);
    });
    bool done = await refreshAll(widget);
    if (done) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CoursesPage(
                  email: widget.email,
                  password: widget.password,
                  school: widget.school,
                  refresh: false,
                )),
      );
    }
    mpsLoading = false;
  }

  FutureBuilder<MPs> buildFutureMPsBuilder() {
    return FutureBuilder(
      future: _futureMPs,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          _dropdownMenuMPS = buildDropdownMenuMPS(snapshot.data!.mps);
          _selectedMP = getMP(_mp, snapshot);
          FocusScope.of(context).unfocus();
          if (!mpsLoading) {
            return SizedBox(
                height: 50,
                width: 100,
                child: Padding(
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
                    )));
          } else {
            return const SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator());
          }
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }

  FutureBuilder<Gpas> buildFutureGpaBuilder() {
    return FutureBuilder(
      future: _futureGpas,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          final ValueNotifier<Widget> gpaCircle =
              ValueNotifier<Widget>(weightedCircle(context, snapshot));
          int gpaCircleNum = 0;
          child = InkWell(
            onTap: () {
              if (gpaCircleNum == 0) {
                gpaCircle.value = unweightedCircle(context, snapshot);
                gpaCircleNum = 1;
              } else {
                gpaCircle.value = weightedCircle(context, snapshot);
                gpaCircleNum = 0;
              }
            },
            child: ValueListenableBuilder<Widget>(
                valueListenable: gpaCircle,
                builder: (BuildContext context, Widget value, Widget? child) {
                  return value;
                }),
          );
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
          return const SizedBox.shrink();
        }
        return child;
      },
    );
  }

  FutureBuilder<Courses> buildFutureCourseBuilder(
      String email, String password, String highschool) {
    return FutureBuilder(
      future: _futureCourses,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          List<dynamic> data = snapshot.data!.courseGrades;

          child = Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                buildFutureGpaBuilder(),
                const SizedBox(
                  height: 20,
                ),
                buildFutureMPsBuilder(),
                apiRowLogic(widget, context),
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
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                    Text(
                                      "${data[index][3]}",
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.blue),
                                    ),
                                    Text(
                                      "${data[index][4]}",
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.blue),
                                    )
                                  ])
                            : Text(
                                "${data[index][3]}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: getColorFromGrade(data[index][3])),
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
                          Navigator.push(
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
          child = RefreshIndicator(
              onRefresh: () async {
                bool done = await refreshAll(widget);
                if (done) {
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CoursesPage(
                              email: widget.email,
                              password: widget.password,
                              school: widget.school,
                              refresh: false,
                            )),
                  );
                }
              },
              child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Padding(
                          padding: const EdgeInsets.all(10), child: child))));
          if (snapshot.data!.courseGrades[0][0] == "N/A") {
            child = createErrorPage(context);
          }
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
        return Scaffold(
          body: child,
          bottomNavigationBar: Navbar(
            selectedIndex: gradesNavNum,
          ),
        );
      },
    );
  }
}

Future<bool> refreshAll(dynamic widget) async {
  //Future.delayed(const Duration(seconds: 2));

  String mp = await mpInCookies();
  await createMPs(widget.email, widget.password, widget.school, true);
  await createGpas(widget.email, widget.password, widget.school, true);
  await createCourses(widget.email, widget.password, widget.school, true);
  await createCoursesDatas(
      widget.email, widget.password, widget.school, mp, true);
  await createScheduleCoursesDatas(
      widget.email, widget.password, widget.school, true);
  await createStudent(widget.email, widget.password, widget.school, true);
  return true;
}
