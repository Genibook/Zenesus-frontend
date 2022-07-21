import 'package:flutter/material.dart';
import 'package:zenesus/widgets/appbar.dart';
import 'dart:async';

class TestingScreen extends StatefulWidget{
  const TestingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _test();

}

class _test extends State<TestingScreen>{
  bool _isLoading=true;

  @override
  void initState() {
    super.initState();

    setState(() {
      _isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CoursesAppbar(),
                !_isLoading
                    ?const Text(
                          "Loading Complete"
                      )
                    :const CircularProgressIndicator(),

          ],
        ),

      ),
    );
  }
}