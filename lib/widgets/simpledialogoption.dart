import 'package:flutter/material.dart';
import 'package:zenesus/serializers/students_name_and_id.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:vibration/vibration.dart';

Future<void> chooseUser(BuildContext context, Student_Name_and_ID data) async {
  List<Widget> createChildren(BuildContext context, Student_Name_and_ID data) {
    List<Widget> myList = [];
    for (int i = 0; i < data.ids.length; i++) {
      myList.add(
        SimpleDialogOption(
          onPressed: () async {
            writeUserNumintoCookies(i);
            if (await Vibration.hasVibrator() ?? false) {
              Vibration.vibrate(duration: 1000);
            }
          },
          child: Text('${data.names[i]} - ${data.ids[i]}'),
        ),
      );
    }
    return myList;
  }

  await showDialog<Student_Name_and_ID>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
            title: const Text('Select Student'),
            children: createChildren(context, data));
      });
}
