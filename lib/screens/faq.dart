import 'package:flutter/material.dart';
import 'package:zenesus/widgets/qaitem.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("FAQ",
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
                          title: Text(
                            "Why is it saying that Genesis is not returning any data?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListTile(title: Text("Solutions")),
                            ListTile(
                                title: Text(
                                    "1. Try to login to Genesis, if you don't see your grades, it would mean that you won't see your grades on the Zenesus app!")),
                            ListTile(
                                title: Text(
                                    "2. This may be because there is indeed no data for that specific part in Genesis")),
                            ListTile(
                                title: Text(
                                    "3. Make sure you are not in airplane mode!/You have wifi!")),
                            ListTile(
                                title: Text(
                                    "4. It may be a server error, please contact me at zenesus.gradebook@gmail.com!")),
                          ]),
                      QAItem(
                          title: Text(
                            "Where is the github repo/source code?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListTile(title: Text("https://github.com/Zenesus")),
                          ]),
                    ])))));
  }
}
