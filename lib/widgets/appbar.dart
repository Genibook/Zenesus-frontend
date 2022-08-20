import 'package:flutter/material.dart';
import 'package:zenesus/screens/firstscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('email');
  await prefs.remove('password');
  await prefs.remove('school');
}

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
        PopupMenuButton<Menu>(
            onSelected: (Menu item) async {
              if (item.index == 0) {
                await logout();

                // ignore: use_build_context_synchronously
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FirstScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                  const PopupMenuItem<Menu>(
                    value: Menu.itemOne,
                    child: Text('Log Out'),
                  ),
                  const PopupMenuItem<Menu>(
                    value: Menu.itemTwo,
                    child: Text('Item 2'),
                  ),
                  const PopupMenuItem<Menu>(
                    value: Menu.itemThree,
                    child: Text('Item 3'),
                  ),
                  const PopupMenuItem<Menu>(
                    value: Menu.itemFour,
                    child: Text('Item 4'),
                  ),
                ])
      ],
    );
  }
}

class CoursesAppbar extends StatelessWidget {
  const CoursesAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        "Zenesus",
        style: TextStyle(
          fontSize: 25,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        PopupMenuButton<Menu>(
            onSelected: (Menu item) async {
              if (item.index == 0) {
                await logout();

                // ignore: use_build_context_synchronously
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FirstScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                  const PopupMenuItem<Menu>(
                    value: Menu.itemOne,
                    child: Text('Log Out'),
                  ),
                  const PopupMenuItem<Menu>(
                    value: Menu.itemTwo,
                    child: Text('Item 2'),
                  ),
                  const PopupMenuItem<Menu>(
                    value: Menu.itemThree,
                    child: Text('Item 3'),
                  ),
                  const PopupMenuItem<Menu>(
                    value: Menu.itemFour,
                    child: Text('Item 4'),
                  ),
                ])
      ],
    );
  }
}
