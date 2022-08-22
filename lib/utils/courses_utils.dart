import 'dart:math';
import 'package:flutter/material.dart';

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

List<double> calculateGradeAverage(List<dynamic> courseGrades) {
  double totalGrade = 0;
  double totalWeightedGrade = 0;
  int lenCourses = courseGrades.length;
  for (int i = 0; i < courseGrades.length; i++) {
    String grade = courseGrades[i][3];
    if (grade != "N/A") {
      double doubleGrade = double.parse(grade);
      totalGrade += doubleGrade;
      String courseName = courseGrades[i][0];
      if (courseName.contains("AP") ||
          courseName.toLowerCase().contains("honors")) {
        totalWeightedGrade += doubleGrade + 5;
      } else {
        totalWeightedGrade += doubleGrade;
      }
    } else if (grade == "N/A") {
      lenCourses -= 1;
    }
  }
  double average = totalGrade / lenCourses;
  double weightedAverage = totalWeightedGrade / lenCourses;
  return [average, weightedAverage];
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
