import 'package:zenesus/serializers/coursedata.dart';

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
