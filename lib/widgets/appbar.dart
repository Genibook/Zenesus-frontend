import 'package:flutter/material.dart';
import 'package:zenesus/screens/firstscreen.dart';
import 'package:zenesus/utils/cookies.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class StudentAppBar extends StatelessWidget {
  const StudentAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: const Text(
        "Account",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        Tooltip(
            message: 'Log out',
            child: IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FirstScreen()),
                );
              },
            )),
      ],
    );
  }
}

class CourseDataPageAppbar extends StatelessWidget {
  const CourseDataPageAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        // title: const Text(
        //   "Zenesus",
        //   style: TextStyle(
        //     fontSize: 25,
        //     letterSpacing: 2,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        );
  }
}
