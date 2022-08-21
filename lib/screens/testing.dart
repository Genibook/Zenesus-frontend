import 'package:zenesus/serializers/courses.dart';
import 'package:zenesus/serializers/mps.dart';
import 'package:flutter/material.dart';
import 'package:zenesus/widgets/appbar.dart';
import 'dart:async';
import 'dart:math';

class TestingScreen extends StatefulWidget {
  const TestingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _test();
}

class _test extends State<TestingScreen> {
  Future<Courses>? _futureCourses;
  Future<MPs>? _futureMPs;
  late List<DropdownMenuItem<String>> _dropdownMenuMPS;
  late String _selectedMP;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _futureCourses = modelCourse();
      _futureMPs = modelMPs();
    });
    return buildFutureCourseBuilder();
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
    });
  }

  FutureBuilder<MPs> buildFutureMPsBuilder() {
    return FutureBuilder(
      future: _futureMPs,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          _dropdownMenuMPS = buildDropdownMenuMPS(snapshot.data!.mps);
          _selectedMP = snapshot.data!.mp;
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

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  FutureBuilder<Courses> buildFutureCourseBuilder() {
    return FutureBuilder(
      future: _futureCourses,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          const double size = 200;
          const double twoPi = pi * 2;
          List<dynamic> data = snapshot.data!.courseGrades;
          double average = calculateGradeAverage(snapshot.data!.courseGrades);
          var brightness = MediaQuery.of(context).platformBrightness;
          bool isDarkMode = brightness == Brightness.dark;
          child = Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
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
                              child: Text("${roundDouble(average, 2)}%",
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold))),
                        ),
                      )
                    ])),
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
                        onTap: () {},
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
