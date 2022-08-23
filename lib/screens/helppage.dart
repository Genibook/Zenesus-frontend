import 'package:flutter/material.dart';

class QAItem extends StatelessWidget {
  const QAItem({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  final Widget title;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: title,
      children: children,
    );
  }
}

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
                        ListTile(
                            title: Text(
                                "1. Try to login to Genesis, if you can't see your picture in the first screen it shows you on the website, then that means that there would be no information in the other pages.")),
                        ListTile(
                            title: Text(
                                "2. There is something wrong with the server, contact me at eddietang2314@gmail.com"))
                      ]),
                ])));
  }
}
