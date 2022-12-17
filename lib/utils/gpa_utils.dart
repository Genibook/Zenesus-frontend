import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zenesus/classes/gpa_history.dart';

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

List<double> calculateGradeAverage(List<dynamic> courseGrades) {
  double totalGrade = 0;
  double totalWeightedGrade = 0;
  int lenCourses = courseGrades.length;
  for (int i = 0; i < courseGrades.length; i++) {
    String grade = courseGrades[i][3].replaceAll("%", "");
    if (grade != "N/A" &&
        grade != "0.0" &&
        grade.toLowerCase() != "no grades") {
      double doubleGrade = double.parse(grade);
      totalGrade += doubleGrade;
      String courseName = courseGrades[i][0];
      if (courseName.contains("AP") ||
          courseName.toLowerCase().contains("honors") ||
          courseName.startsWith("H-")) {
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

MaterialColor getColorFromGrade(dynamic grade) {
  try {
    if (grade != "No Grades" && grade != "No Grades") {
      grade = double.parse(grade);
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
      } else if (50 > grade && grade != 0.0) {
        return Colors.red;
      } else if (grade == -1) {
        return Colors.red;
      } else {
        return Colors.blue;
      }
    } else {
      return Colors.blue;
    }
  } catch (e) {
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
    } else if (50 > grade && grade != 0.0) {
      return Colors.red;
    } else if (grade == -1) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }
}

List<double> getTotalGpas(GPAHistorys history) {
  // [weighted, unweighted]

  

  int totalLength = history.datas.length;
  double unweightedTotal = 0;
  double weightedTotal = 0;

  int lessTotalLength = 0;
  double lessUnweightedTotal = 0;
  double lessWeightedTotal = 0;
  for (int i = 0; i < totalLength; i++) {
    if (double.parse(history.datas[i].grade) >= 9) {
      unweightedTotal += history.datas[i].unweightedGPA;
      weightedTotal += history.datas[i].weightedGPA;
    } else {
      lessUnweightedTotal += history.datas[i].unweightedGPA;
      lessWeightedTotal += history.datas[i].weightedGPA;
      totalLength -= 1;
      lessTotalLength += 1;
    }
  }

  if (totalLength > 0) {
    return [
      roundDouble(weightedTotal / totalLength, 2),
      roundDouble(unweightedTotal / totalLength, 2)
    ];
  } else {
    if (lessTotalLength == 0) {
      return [0, 0];
    }
    return [
      roundDouble(lessWeightedTotal / lessTotalLength, 2),
      roundDouble(lessUnweightedTotal / lessTotalLength, 2)
    ];
  }
}
