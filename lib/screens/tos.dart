import 'package:flutter/material.dart';
import 'package:zenesus/widgets/qaitem.dart';

class TOSpage extends StatefulWidget {
  const TOSpage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HelpPageState();
}

class HelpPageState extends State<TOSpage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Privacy Policy",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        ),
        body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                      QAItem(
                          title: Text(
                            "Introduction",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListTile(
                                title: Text(
                                    "Thank you for choosing to be part of our Community at Zenesus ('Company', 'we', 'us', or 'our'). We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns please contact us at zenesus.gradebook@gmail.com.")),
                            ListTile(
                                title: Text(
                                    "This privacy notice describes how we might use your information if you download or use our application -- Zenesus.")),
                            ListTile(
                                title: Text(
                                    "In this privacy notice if we refer to 'App' we are refering to any application of ours that references or links to this policy, including any listed above.")),
                            ListTile(
                                title: Text(
                                    "The purpose of this privacy notice is to explain to you in the clearest way possible what information we collect, how we use it, and what rights you have in relatiom to it.")),
                          ]),
                      QAItem(
                          title: Text(
                            "What Information do we Collect?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListTile(
                              title: Text(
                                "1. Personal Information You Disclose",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                  "We NEVER store any data you disclose into a remote location where only the developer of this app can access."),
                            ),
                            ListTile(
                              title: Text(
                                  "However, we do store data that the user discloses onto the user's physical device itself."),
                            ),
                            ListTile(
                              title: Text(
                                "2. Information Automatically Collected",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                  "Using the information the user gave, we will automatically calcualte and collect grades from Genesis -- such as your grades, assignments, GPA, and Genesis account details"),
                            ),
                            ListTile(
                              title: Text(
                                "3. Information Collected Through the App",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                  "We collect information regarding your mobile device, such as the users current system theme."),
                            ),
                            ListTile(
                              title: Text(
                                "4. Information Collected from other Sources",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                  "In Short: We collect information from Genesis Parent Portal."),
                            ),
                            ListTile(
                              title: Text(
                                  "We collect current grades, assignments, GPA, and other account data from your Genesis Parent Portal."),
                            ),
                          ]),
                      QAItem(
                          title: Text(
                            "How do we use your Information?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListTile(
                              title: Text(
                                  "We use your information to send notifications, show realtime grades, assignments, GPA, and account details."),
                            ),
                          ]),
                      QAItem(
                          title: Text(
                            "Will your information be shared with anyone?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListTile(
                              title: Text(
                                  "We only share information with your consent, to comply with laws, to provide you with services, or to protect your rights."),
                            ),
                          ]),
                      QAItem(
                          title: Text(
                            "How long do we keep your information?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListTile(
                              title: Text(
                                  "As said above, this app will never store inforamation on a database, therefore meaning everytime you leave a page in this app, we dispose the information on the page."),
                            ),
                          ]),
                      QAItem(
                          title: Text(
                            "How do we keep your information safe?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListTile(
                              title: Text(
                                  "We aim to protect your personal information through a system of organizational and technical security measures. We have implemented appropriate technical and organizational security measures designed to protect the security of any personal information we process. However, despite our safeguards and efforts to secure your information, no electronic transmission over the internet or information storage technology can be guaranteed to be 100% secure, so we cannot promise or guarantee that hackers, cybercriminals, or other unauthorized third parties will not be able to defeat our security, and improperly collect, access, steal, or modify your information. Although we will do our best to protect your personal information, the transmission of personal information to and from our App is at your own risk. You should only access the App within a secure environment."),
                            ),
                          ]),
                      QAItem(
                          title: Text(
                            "Do we make updates to this Notice?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListTile(
                              title: Text(
                                  "Yes, we will update this notice as neccessary to stay compliant with relevant laws. As such, we encourage you to review this privacy notice frequently to be informed of how we are protecting your information."),
                            ),
                          ]),
                      QAItem(
                          title: Text(
                            "How can you review, update, or delete the data we collect from you?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          children: [
                            ListTile(
                              title: Text(
                                  "Based on the applicable law of your country, you may have the right to request access to your personal information we collect from you, change that information, or delete it in some circumstances. To request to review, update, or delete your personal information, please submit a request form by contacting us at zenesus.gradebook@gmail.com."),
                            ),
                          ]),
                    ])))));
  }
}
