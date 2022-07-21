import 'package:flutter/material.dart';
import 'package:zenesus/screens/LoginGrades.dart';
import 'package:shared_preferences/shared_preferences.dart';
enum Menu { itemOne, itemTwo, itemThree, itemFour }

class LoginAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return
        AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title:
          const Text("Zenesus",
            style:
            TextStyle(
              fontSize: 25,
              letterSpacing: 7,
              fontWeight: FontWeight.bold,
              fontFamily: "Merriweather",

            ),
          ),
        );
  }
}
class CoursesAppbar extends StatelessWidget{

  Future<void> Logout() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('school');
  }

  @override
  Widget build(BuildContext context){
    return
      AppBar(
        automaticallyImplyLeading: false,
        title:
        const Text("Zenesus",
          style:
          TextStyle(
            fontSize: 25,
            letterSpacing: 7,
            fontWeight: FontWeight.bold,
            fontFamily: "Merriweather",

          ),
        ),
        actions: <Widget>[
          PopupMenuButton<Menu>(
            // Callback that sets the selected popup menu item.
              onSelected: (Menu item) async {
                // setState(() {
                //   _selectedMenu = item.name;
                // });
                if(item.index==0){

                  // final prefs = await SharedPreferences.getInstance();
                  // final email = prefs.getString('email') ?? "";
                  // final password = prefs.getString('password') ?? "";
                  // final school = prefs.getString('school') ?? "";
                  //
                  // print(email);
                  // print(password);
                  // print(school);

                  await Logout();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const waitScreen()),
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





