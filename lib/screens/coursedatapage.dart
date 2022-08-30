import 'package:zenesus/serializers/coursedata.dart';
import 'package:flutter/material.dart';
import 'package:zenesus/utils/course_datas_utils.dart';
import 'dart:async';
import 'package:zenesus/utils/courses_utils.dart';
import 'package:zenesus/screens/error.dart';
import "package:zenesus/routes/hero_dialog_route.dart";

const String _heroAddTodo = 'add-todo-hero';

Widget getFromPercent(double percentChange, String mode) {
  if (mode == "image") {
    if (percentChange > 0) {
      return Image.asset("assets/increase.png");
    } else if (percentChange < 0) {
      return Image.asset("assets/decrease.png");
    } else {
      return Image.asset("assets/noChange.png");
    }
  } else if (mode == "text") {
    if (percentChange > 0) {
      return Text(
        "Your average grade had a $percentChange% increase because of this assignment.",
        textAlign: TextAlign.center,
      );
    } else if (percentChange < 0) {
      return Text(
          "Your average grade had a $percentChange% decrease because of this assignment.",
          textAlign: TextAlign.center);
    } else {
      return const Text(
          "Your average grade stayed the same after this assignment was graded.",
          textAlign: TextAlign.center);
    }
  } else {
    return const SizedBox.shrink();
  }
}

class _GradePopupCard extends StatelessWidget {
  const _GradePopupCard(
      {Key? key,
      required this.course,
      required this.percentChange,
      required this.currentAvg,
      required this.oldAvg})
      : super(key: key);

  final CoursesData course;
  final double percentChange;
  final double currentAvg;
  final double oldAvg;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddTodo,
          child: Material(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getFromPercent(percentChange, "image"),
                    getFromPercent(percentChange, "text"),
                    const Divider(
                      thickness: 3,
                    ),
                    Text(
                      "${course.category}",
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "${course.assignment}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "${course.teacher}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    Text("${course.full_dayname} ${course.full_date}"),
                    const Divider(
                      thickness: 3,
                    ),
                    Column(
                      children: [
                        Text(
                          "Comment: ${course.comment}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "Description: ${course.description}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
    _futureCoursesData = modelCourseDatas();

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
                            "${courseAssignments[index].dayname} ${courseAssignments[index].date} - ${courseAssignments[index].mp}"),
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
                        onTap: () {
                          List<double> percentChange =
                              getChangeBecauseOfGradePercent(allData,
                                  courseAssignments[index].course_name, index);
                          Navigator.of(context)
                              .push(HeroDialogRoute(builder: (context) {
                            return _GradePopupCard(
                              course: courseAssignments[index],
                              percentChange: percentChange[0],
                              currentAvg: percentChange[1],
                              oldAvg: percentChange[2],
                            );
                          }));
                        },
                      );
                    })
              ],
            );
            child = SingleChildScrollView(
                physics: const ScrollPhysics(),
                child:
                    Padding(padding: const EdgeInsets.all(10), child: child));
            try {
              if (snapshot.data!.datas[0][0].course_name == "N/A" &&
                  snapshot.data!.datas[0][0].mp == "N/A") {
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
