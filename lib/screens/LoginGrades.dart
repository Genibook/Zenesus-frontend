
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenesus/screens/login.dart';
import 'package:zenesus/screens/courses.dart';

class waitScreen extends StatefulWidget{
  const waitScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _screen();
}



class _screen extends State<waitScreen>{
  String quote = "";
  String author = "";
  late String email;
  late String password;
  late String school;

  @override
  void initState() {
    super.initState();
     _getQuote();
     _getAuthor();
    _getUserData();
  }

  void _getUserData() async{
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? "";
    password = prefs.getString('password') ?? "";
    school = prefs.getString('school') ?? "";

    // remove data
    // final prefs = await SharedPreferences.getInstance();
    //
    // await prefs.remove('counter');

    if(email == "" && password == "" && school == ""){
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => const MyLoginPage(incorrect: false,)),
       );
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Courses(email: email, password: password, school: school)),
      );

    }

  }


  void _getQuote() async {
    final res = await http.get(Uri.parse('http://quotes.rest/qod.json'));
    quote =  json.decode(res.body)['contents']['quotes'][0]['quote'];
    setState(() {
      quote=quote;
    });
  }

  void _getAuthor() async {
    final res = await http.get(Uri.parse('http://quotes.rest/qod.json'));
    author = json.decode(res.body)['contents']['quotes'][0]['author'];
    setState(() {
      author=author;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20,),
                  Text(
                    quote,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "Merriweather",
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Text(
                    author,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "Merriweather",
                      fontWeight: FontWeight.bold,

                    ),
                  )

                ]
            )
        )

    );
  }

}