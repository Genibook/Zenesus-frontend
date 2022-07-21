import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenesus/screens/login.dart';
import 'package:zenesus/widgets/appbar.dart';

class Courses extends StatefulWidget{
  const Courses({Key? key, required this.email, required this.password, required this.school}) : super(key: key);
  final String email;
  final String password;
  final String school;

  @override
  State<StatefulWidget> createState() => _courses();
}

class _courses extends State<Courses>{
  Map<String, dynamic> decoded = {};
  Map<String, dynamic> code = {};
  String _selectedMenu = '';

  @override
  void initState() {
    super.initState();
    final String email = widget.email;
    final String password = widget.password;
    final String school = widget.school;

    _fetchThings(email, password, school);

  }

  void _fetchThings(String email, String password, String school) async {
    const url = 'http://10.0.2.2:5000/api/login';

    final post = await http.post(
        Uri.parse(url),
        body: json.encode(
          {'email' : email,
            "password": password,
            'highschool':school,
          }
      )
    );

      code = json.decode(post.body) as Map<String, dynamic>;
      if(code['code']==420){
        final response = await http.get(Uri.parse(url));

        decoded = json.decode(response.body) as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setString('school', school);

      }

      if(code['code']==69){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyLoginPage(incorrect: true,)),
        );
      }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                  CoursesAppbar(),
                const CircularProgressIndicator()

              ],
          ),

      ),
    );
  }


}