import 'package:flutter/material.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/screens/coursespage.dart';
import 'package:zenesus/screens/studentpage.dart';

class Navbar extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Navbar({Key? key, required this.selectedIndex, required this.isBday});
  final int selectedIndex;
  final bool isBday;
  @override
  State<StatefulWidget> createState() => NavBarState();
}

class NavBarState extends State<Navbar> {
  late int _selectedIndex;
  late String email;
  late String password;
  late String school;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex = widget.selectedIndex;
    });
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    List<String> things = await readEmailPassSchoolintoCookies();
    email = things[0];
    password = things[1];
    school = things[2];

    if (index == 0) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CoursesPage(
                  email: email,
                  password: password,
                  school: school,
                )),
      );
    } else if (index == 1) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentPage(
                  email: email,
                  password: password,
                  school: school,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.text_increase),
          label: 'Grades',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      backgroundColor: widget.isBday ? Colors.amber[700] : null,
      selectedItemColor: widget.isBday
          ? Colors.white
          : const Color.fromARGB(255, 33, 168, 245),
      onTap: _onItemTapped,
    );
  }
}
