import 'package:zenesus/classes/courses.dart';
import 'package:zenesus/classes/mps.dart';
import 'package:zenesus/classes/gpas.dart';
import 'package:zenesus/classes/coursedata.dart';
import 'package:zenesus/classes/schedules.dart';
import 'package:zenesus/classes/student.dart';
import 'package:zenesus/classes/gpa_history.dart';
import 'package:zenesus/screens/coursespage.dart';
import 'package:flutter/material.dart';
import 'package:zenesus/utils/cookies.dart';

Widget apitestingrow(dynamic widget, dynamic context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      ElevatedButton(
          onPressed: (() async {
            await createHistoryGpas(
                widget.email, widget.password, widget.school, false);
          }),
          child: const SizedBox(
              height: 50,
              width: 70,
              child: Text(
                "gpahistory",
                textAlign: TextAlign.center,
              ))),
      ElevatedButton(
          onPressed: (() async {
            await createScheduleCoursesDatas(
                widget.email, widget.password, widget.school, true);
          }),
          child: const SizedBox(
              height: 50,
              width: 70,
              child: Text(
                "schedule api",
                textAlign: TextAlign.center,
              ))),
      ElevatedButton(
          onPressed: (() async {
            String mp = await mpInCookies();
            await createCoursesDatas(
                widget.email, widget.password, widget.school, mp, true);
          }),
          child: const SizedBox(
              height: 50,
              width: 70,
              child: Text(
                "course datas api",
                textAlign: TextAlign.center,
              ))),
      ElevatedButton(
          onPressed: (() async {
            await createCourses(
                widget.email, widget.password, widget.school, true);
          }),
          child: const SizedBox(
              height: 50,
              width: 70,
              child: Text(
                "courses api",
                textAlign: TextAlign.center,
              ))),
      ElevatedButton(
          onPressed: (() async {
            await createGpas(
                widget.email, widget.password, widget.school, true);
          }),
          child: const SizedBox(
              height: 50,
              width: 70,
              child: Text(
                "gpa api",
                textAlign: TextAlign.center,
              ))),
      ElevatedButton(
          onPressed: (() async {
            await createMPs(widget.email, widget.password, widget.school, true);
          }),
          child: const SizedBox(
              height: 50,
              width: 70,
              child: Text(
                "mp api",
                textAlign: TextAlign.center,
              ))),
      ElevatedButton(
          onPressed: (() async {
            await createStudent(
                widget.email, widget.password, widget.school, true);
          }),
          child: const SizedBox(
              height: 50,
              width: 70,
              child: Text(
                "student api",
                textAlign: TextAlign.center,
              ))),
      ElevatedButton(
          onPressed: (() async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CoursesPage(
                        email: widget.email,
                        password: widget.password,
                        school: widget.school,
                        refresh: false,
                      )),
            );
          }),
          child: const SizedBox(
              height: 50,
              width: 70,
              child: Text(
                "refresh",
                textAlign: TextAlign.center,
              ))),
    ],
  );
}
