import 'package:zenesus/screens/firstscreen.dart';
import 'package:zenesus/screens/faq.dart';
import 'package:flutter/material.dart';
import 'package:zenesus/icons/custom_icons_icons.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}

Widget createErrorPage(dynamic context) {
  return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/404.png",
            width: 250,
            height: 250,
          ),
          const Text("Sorry, Genesis is not giving us data ☹...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          const Text("Maybe one of these will help?"),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Tooltip(
                message: "Sign into Genesis",
                child: IconButton(
                  icon: const Icon(CustomIcons.idBadge),
                  onPressed: () => _launchUrl(
                      "https://parents.mtsd.k12.nj.us/genesis/parents"),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Tooltip(
                message: "View our help page",
                child: IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.question_mark),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpPage()),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Tooltip(
                message: "Logout",
                child: IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FirstScreen()),
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ));
}
