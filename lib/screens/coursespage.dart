import 'package:zenesus/serializers/courses.dart';
import 'package:flutter/material.dart';
import 'package:zenesus/widgets/appbar.dart';
import 'dart:async';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _futureCourses =
          createCourses(widget.email, widget.password, widget.school);
    });
    return buildFutureBuilder();
  }

  MaterialColor getColorFromGrade(double grade) {
    if (grade >= 90) {
      return Colors.green;
    } else if ((90 > grade) && (grade >= 80)) {
      return Colors.yellow;
    } else if ((80 > grade) && (grade >= 70)) {
      return Colors.amber;
    } else if ((70 > grade) && (grade >= 60)) {
      return Colors.orange;
    } else if ((60 > grade) && (grade >= 50)) {
      return Colors.deepOrange;
    } else if (50 > grade) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  double calculateGradeAverage(List<dynamic> courseGrades) {
    double totalGrade = 0;
    int lenCourses = courseGrades.length;
    for (int i = 0; i < courseGrades.length; i++) {
      String grade = courseGrades[i][3];
      if (grade != "N/A") {
        double doubleGrade = double.parse(grade);
        totalGrade += doubleGrade;
      } else if (grade == "N/A") {
        lenCourses -= 1;
      }
    }
    double average = totalGrade / lenCourses;
    return average;
  }

  FutureBuilder<Courses> buildFutureBuilder() {
    return FutureBuilder(
      future: _futureCourses,
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          const double size = 200;
          const double twoPi = 3.14 * 2;
          List<dynamic> data = snapshot.data!.courseGrades;
          double average = calculateGradeAverage(snapshot.data!.courseGrades);
          var brightness = MediaQuery.of(context).platformBrightness;
          bool isDarkMode = brightness == Brightness.dark;
          children = [
            Container(
                width: size,
                height: size,
                child: Stack(children: [
                  ShaderMask(
                    shaderCallback: (rect) {
                      return SweepGradient(
                          startAngle: 0,
                          endAngle: twoPi,
                          stops: [average / 100, average / 100],
                          // 0.0, 0.5, 0.5, 1.0
                          center: Alignment.center,
                          colors: [
                            getColorFromGrade(average),
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
                          child: Text(
                              "${double.parse((average).toStringAsFixed(2))}%",
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold))),
                    ),
                  )
                ])),
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
                    onTap: () {},
                  );
                }),
          ];
        } else if (snapshot.hasError) {
          children = <Widget>[
            const CoursesAppbar(),
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
            CoursesAppbar(),
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
            body: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: children,
                  ),
                )));
      },
    );
  }
}
