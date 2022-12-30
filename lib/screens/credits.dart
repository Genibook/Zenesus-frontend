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
                        children: [
                      QAItem(
                          title: const Text("What is this?",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          children: const [
                            ListTile(
                                title: Text(
                                    "This page is dedicated for all the people who helped me build/test this app, and my words for them.")),
                            ListTile(
                                title: Text(
                                    "Btw - Congrats!!! You found a / the first easter egg made for this app!")),
                          ]),
                      QAItem(
                          title: const Text(
                            "Etaash Mathamsetty and Justin",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: const [
                            ListTile(
                                title: Text(
                                    "Etaash became my first daily beta tester on 8/31/2022. Since he used linux, he helped me compile and format the different versions of the app so that other linux users can use Zenesus.")),
                            ListTile(
                              title: Text(
                                  "He gave me a lot of valuable suggestions."),
                            ),
                          ]),
                      QAItem(
                          title: const Text(
                            "First Android Beta Testing Group",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: const [
                            ListTile(
                                title: Text(
                                    "These people include Etaash, Justin, Jason, and Ann")),
                          ]),
                      QAItem(
                          title: const Text(
                            "Windows testing group",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: const [
                            ListTile(
                                title: Text(
                                    "Big thanks to Siddarth - who was one of the first people to test out the website I built to display Genesis data.")),
                            ListTile(
                              title: Text(
                                  "Many features that Zenesus has today originated from him."),
                            ),
                          ]),
                      QAItem(
                          title: const Text(
                            "Students and Parents",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: const [
                            ListTile(
                                title: Text(
                                    "I give thanks to all the students who participated in beta testing, and all the student/parents who are using/used Zenesus.")),
                          ]),
                    ])))));
  }
}
