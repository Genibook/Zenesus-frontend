import 'package:zenesus/serializers/coursedata.dart';
import 'package:flutter/material.dart';
import 'package:zenesus/utils/course_datas_utils.dart';
import 'dart:async';
import 'package:zenesus/utils/courses_utils.dart';
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
    _futureCoursesData = createCoursesDatas(
        widget.email, widget.password, widget.school, widget.mp);
    //_futureCoursesData = modelCourseDatas();

    return buildFutureCoursesDataPage();
  }

  FutureBuilder<CoursesDatas> buildFutureCoursesDataPage() {
    return FutureBuilder(
      future: _futureCoursesData,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          try {
            List<List<CoursesData>> allData = snapshot.data!.datas;
            List<CoursesData> courseAssignments =
                getCourse(allData, widget.courseName);
            child = Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView.separated(
                    separatorBuilder: (_, __) => const Divider(),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: getLength(allData, widget.courseName),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        enabled: true,
                        selected: false,
                        title: Text(
                          "${courseAssignments[index].assignment}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        subtitle: Text(
                            "${courseAssignments[index].dayname} ${courseAssignments[index].date}"),
                        trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${courseAssignments[index].grade_percent}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: getColorFromGrade(double.parse(
                                        courseAssignments[index]
                                            .grade_percent))),
                              ),
                              Text("${courseAssignments[index].grade_num}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: getColorFromGrade(double.parse(
                                          courseAssignments[index]
                                              .grade_percent)))),
                            ]),
                        //TODO
                        onTap: () {
                          throw UnimplementedError();
                        },
                      );
                    })
              ],
            );
            if (snapshot.data!.datas[0][0].course_name == "N/A" &&
                snapshot.data!.datas[0][0].mp == "N/A") {
              child = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Center(child: createErrorPage(context))]);
            }
          } catch (e) {
            print(e);
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
                    child: Text('Someone went wrong  - please refresh the app'),
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
