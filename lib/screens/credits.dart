import 'package:flutter/material.dart';
import 'package:zenesus/widgets/qaitem.dart';

class CreditsPage extends StatefulWidget {
  const CreditsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CreditsPageState();
}

class CreditsPageState extends State<CreditsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Credits",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                      QAItem(
                          title: Text("What is this?",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          children: [
                            ListTile(
                                title: Text(
                                    "This page is dedicated for all the people who helped me build/test this app, and my words for them.")),
                            ListTile(
                                title: Text(
                                    "Btw - Congrats!!! You found a / the first easter egg made for this app!")),
                          ]),
                      QAItem(
                          title: Text(
                            "Linux app compiler - Etaash Mathamsetty",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListTile(
                                title: Text(
                                    "Etassh became my first beta tester on 8/31/2022. Since he used linux, he helped me compile and format the different versions of the app so that other linux users can use Zenesus.")),
                          ]),
                      QAItem(
                          title: Text(
                            "The Unnamed Student",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListTile(
                                title: Text(
                                    "I give thanks to all the students who participated in beta testing, and all the student/parents who are/used Zenesus.")),
                          ]),
                      QAItem(
                          title: Text(
                            "Parents and Sister",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListTile(
                                title: Text(
                                    "They all supported me in the making of this app while urging me to also focus on my school work.")),
                          ]),
                    ])))));
  }
}
