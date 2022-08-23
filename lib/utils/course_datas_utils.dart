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
