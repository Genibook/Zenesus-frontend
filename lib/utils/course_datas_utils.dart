import 'package:zenesus/serializers/coursedata.dart';
import 'package:zenesus/utils/courses_utils.dart';
import 'package:flutter/material.dart';

const String _heroAddTodo = 'add-todo-hero';
void PrintData(List<CoursesData> data) {
  int idxx = 0;

  for (CoursesData subdata in data) {
    print("~~~~");
    print(subdata.course_name);
    print(subdata.assignment);
    print("~~~~");

    print(idxx);
    print("~~~~");
    idxx++;
  }
}

void PrintDatas(List<List<CoursesData>> datas) {
  int idx = 0;
  int idxx = 0;

  for (List<CoursesData> data in datas) {
    print("^^^");
    print(idx);
    print("^^^");
    idx++;
    for (CoursesData subdata in data) {
      print("~~~~");
      print(subdata.course_name);
      print(subdata.assignment);
      print("~~~~");

      print(idxx);
      print("~~~~");
      idxx++;
    }
  }
}

double getAvgofList(List<double> list) {
  // if change is 0, grey, if change is +, green, if change is -, red
  int length = list.length;
  double gradeadded = 0;
  for (double grade in list) {
    gradeadded += grade;
  }
  if (list.isNotEmpty) {
    return roundDouble(gradeadded / length, 2);
  } else {
    return 0.0;
  }
}

List<double> getChangeBecauseOfGradePercent(
    List<List<CoursesData>> allData, String courseName, int index) {
  List<double> allcoursegrades = [];

  //Print(allData);
  if (allData[0].isEmpty) {
    // print("returned 0");
    return [0.0, 0.0, 0.0];
  }
  for (int i = 0; i < allData.length; i++) {
    if (allData[i].isEmpty) {
      continue;
    }

    // print("----");
    // print(allData[i][0].course_name);
    // print("----");

    if (allData[i][0].course_name == courseName) {
      //first index (0) is always the most recent grade/assignment graded
      for (CoursesData courseData in allData[i]) {
        double doubleGrade = double.parse(courseData.grade_percent);
        allcoursegrades.add(doubleGrade);
      }
    }
  }

  List<double> sublist1 = allcoursegrades.sublist(index);
  List<double> sublist2 = allcoursegrades.sublist(index + 1);
  double avgSublist2 = getAvgofList(sublist2);
  double avgSublist1 = getAvgofList(sublist1);
  if (avgSublist2 != 0) {
    double percentChange =
        roundDouble(((avgSublist1 - avgSublist2) / avgSublist2) * 100, 2);
    return [percentChange, avgSublist1, avgSublist2];
  } else {
    return [0.0, avgSublist1, avgSublist2];
  }

  // print("weird...");
}

// first index is the coursework
// second index is the length of the coursework
int getLength(List<List<CoursesData>> allData, String courseName) {
  // print("getting length");
  if (allData[0].isEmpty) {
    // print("returned 0");
    return 0;
  }
  for (List<CoursesData> courseWork in allData) {
    if (courseWork.isNotEmpty) {
      if (courseWork[0].course_name == courseName) {
        // print("found it!");
        return courseWork.length;
      }
    }
  }
  // print("weird...");
  return 0;
}

List<CoursesData> getCourse(
    List<List<CoursesData>> allData, String courseName) {
  if (allData[0].isEmpty) {
    return [
      CoursesData.fromJson(
        {
          "course_name": "N/A",
          "mp": "N/A",
          "dayname": "N/A",
          "full_dayname": "N/A",
          "date": "N/A",
          "full_date": "N/A",
          "teacher": "N/A",
          "category": "N/A",
          "assignment": "N/A",
          "description": "N/A",
          "grade_percent": "N/A",
          "grade_num": "N/A",
          "comment": "N/A",
          "prev": "N/A",
          "docs": "N/A"
        },
      )
    ];
  }
  for (List<CoursesData> courseWork in allData) {
    if (courseWork.isNotEmpty) {
      if (courseWork[0].course_name == courseName) {
        return courseWork;
      }
    }
  }
  return [
    CoursesData.fromJson(
      {
        "course_name": "N/A",
        "mp": "N/A",
        "dayname": "N/A",
        "full_dayname": "N/A",
        "date": "N/A",
        "full_date": "N/A",
        "teacher": "N/A",
        "category": "N/A",
        "assignment": "N/A",
        "description": "N/A",
        "grade_percent": "N/A",
        "grade_num": "N/A",
        "comment": "N/A",
        "prev": "N/A",
        "docs": "N/A"
      },
    )
  ];
}

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

class GradePopupCard extends StatelessWidget {
  const GradePopupCard(
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
                    Text("$oldAvg% ➡ $currentAvg%"),
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
                          "${course.description}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "${course.comment}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
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
