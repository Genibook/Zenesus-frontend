import 'package:zenesus/serializers/coursedata.dart';

// first index is the coursework
// second index is the length of the coursework
int getLength(List<List<CoursesData>> allData, String courseName) {
  for (List<CoursesData> courseWork in allData) {
    if (courseWork[0].course_name == courseName) {
      return courseWork.length;
    }
  }
  return 0;
}

List<CoursesData> getCourse(
    List<List<CoursesData>> allData, String courseName) {
  for (List<CoursesData> courseWork in allData) {
    if (courseWork[0].course_name == courseName) {
      return courseWork;
    }
  }
  return [
    CoursesData.fromJson(
      {
        "course_name": "Error",
        "mp": "Error",
        "dayname": "Error",
        "full_dayname": "Error",
        "date": "Error",
        "full_date": "Error",
        "teacher": "Error",
        "category": "Error",
        "assignment": "Error",
        "description": "Error",
        "grade_percent": "Error",
        "grade_num": "Error",
        "comment": "Error",
        "prev": "Error",
        "docs": "Error"
      },
    )
  ];
}
