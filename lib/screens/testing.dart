import 'dart:io';
import 'package:zenesus/serializers/courses.dart';
import 'package:flutter/material.dart';
import 'package:zenesus/widgets/appbar.dart';
import 'dart:async';

class TestingScreen extends StatefulWidget {
  const TestingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _test();
}

class _test extends State<TestingScreen> {
  Future<Courses>? _futureCourses;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _futureCourses = modelCourse();
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

  FutureBuilder<Courses> buildFutureBuilder() {
    return FutureBuilder(
      future: _futureCourses,
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          List<dynamic> data = snapshot.data!.courseGrades;
          children = [
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
                                fontSize: 20,
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
