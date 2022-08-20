import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradesPage extends StatefulWidget {
  const GradesPage(
      {Key? key,
      required this.email,
      required this.password,
      required this.school})
      : super(key: key);
  final String email;
  final String password;
  final String school;

  @override
  State<StatefulWidget> createState() => GradePageState();
}

class GradePageState extends State<GradesPage> {
  @override
  void initState() {
    super.initState();
    final String email = widget.email;
    final String password = widget.password;
    final String school = widget.school;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: const [Text("hi")]),
      //TODO: IMPLEMENT THE LOG BETWEEN DOING THE VERIFICATION
    );
  }
}
