import 'package:zenesus/classes/coursedata.dart';
import 'package:flutter/material.dart';
import 'package:zenesus/constants.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/utils/course_datas_utils.dart';
import 'dart:async';

import 'package:zenesus/screens/error.dart';

class CourseDatasPage extends StatefulWidget {
  const CourseDatasPage(
      {Key? key,
      required this.email,
      required this.password,
      required this.school,
      required this.courseName,
      required this.mp})
      : super(key: key);
  final String email;
  final String password;
  final String school;
  final String courseName;
  final String mp;

  @override
  State<StatefulWidget> createState() => CourseDatasState();
}

class CourseDatasState extends State<CourseDatasPage> {
  Future<CoursesDatas>? _futureCoursesData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (TEST_DATA) {
        _futureCoursesData = modelCourseDatas();
      } else {
        _futureCoursesData = createCoursesDatas(
            widget.email, widget.password, widget.school, widget.mp, false);
      }
    });

    return buildFutureCoursesDataPage();
  }

  FutureBuilder<CoursesDatas> buildFutureCoursesDataPage() {
    return FutureBuilder(
      future: _futureCoursesData,
      builder: (context, snapshot) {
        Widget child;
        List<Widget> children;
        if (snapshot.hasData) {
          try {
            List<List<CoursesData>> allData = snapshot.data!.datas;

            Future<bool> gradeProjToggle = readGradeProjectionsToggle();
            children = [
              FutureBuilder(
                  future: gradeProjToggle,
                  builder: ((context, AsyncSnapshot<bool?> snapshot) {
                    if (snapshot.hasData) {
                      List<CoursesData> courseAssignments =
                          getCourse(allData, widget.courseName, snapshot.data!);

                      return ListView.separated(
                          separatorBuilder: (_, __) => const Divider(),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: courseAssignments.length,
                          itemBuilder: (BuildContext context, int index) {
                            CoursesData classs = courseAssignments[index];
                            if (classs.full_dayname == NONE_STRING &&
                                classs.teacher == NONE_STRING &&
                                classs.grade_percent == NONE_STRING &&
                                classs.comment == NONE_STRING &&
                                snapshot.data!) {
                              return createCourseDataNotGradedTile(
                                  courseAssignments, index);
                            } else {
                              return createCourseDataTile(
                                  courseAssignments, index, context, allData);
                            }
                          });
                    } else {
                      return const ListTile();
                    }
                  })),
            ];
            child = ListView(
                physics: const ScrollPhysics(),
                // Padding(padding: const EdgeInsets.all(10), child: child)
                children: children);
            try {
              if (snapshot.data!.datas[0][0].course_name == NONE_STRING &&
                  snapshot.data!.datas[0][0].mp == NONE_STRING) {
                child = Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Center(child: createErrorPage(context))]);
              }
            } catch (e) {
              //print(e);
              if (snapshot.data!.datas[0].isEmpty) {
                child = Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Center(child: createErrorPage(context))]);
              }
            }
          } catch (e) {
            //print(e);
            child = Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Someone went wrong  - please contact us'),
                  )
                ]));
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

        return Scaffold(appBar: AppBar(), body: child);
      },
    );
  }
}
