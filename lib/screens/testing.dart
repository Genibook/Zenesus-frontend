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
    setState(() {
      _futureCourses = modelCourse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilder();
  }

  FutureBuilder<Courses> buildFutureBuilder() {
    return FutureBuilder(
      future: _futureCourses,
      builder: (context, snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          children = [
            Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data!.length(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        // leading: const Icon(Icons.list),
                        title: Text("${snapshot.data!.courseGrades[index]}"));
                  }),
            ),
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
            body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        ));
      },
    );
  }
}
