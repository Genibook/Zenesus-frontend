import 'package:zenesus/serializers/coursedata.dart';
import 'package:zenesus/utils/courses_utils.dart';

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
  if (allData[0].isEmpty) {
    // print("returned 0");
    return [0.0, 0.0, 0.0];
  }
  for (int i = 0; i < allData.length; i++) {
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
    if (courseWork[0].course_name == courseName) {
      // print("found it!");
      return courseWork.length;
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
    if (courseWork[0].course_name == courseName) {
      return courseWork;
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
