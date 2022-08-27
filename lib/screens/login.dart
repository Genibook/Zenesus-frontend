import 'package:flutter/material.dart';
import 'package:zenesus/icons/custom_icons_icons.dart';
import 'package:zenesus/serializers/connections.dart';
// import 'package:zenesus/screens/studentpage.dart';
import 'package:zenesus/screens/coursespage.dart';
import 'package:zenesus/screens/tos.dart';
import 'package:zenesus/utils/cookies.dart';
import 'package:zenesus/serializers/mps.dart';

class Highschool {
  late int id;
  late String name;

  Highschool(this.id, this.name);

  static List<Highschool> getHighschools() {
    return <Highschool>[
      Highschool(0, "Select a School District"),
      Highschool(1, "Montgomery")
    ];
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  State<MyLoginPage> createState() => _Login();
}

class _Login extends State<MyLoginPage> {
  late bool _passwordVisible = false;
  bool _isLoading = false;

  final List<Highschool> _highschools = Highschool.getHighschools();
  late List<DropdownMenuItem<Highschool>> _dropdownMenuItems;
  late Highschool _selectedHighschool;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_highschools);
    _selectedHighschool = _dropdownMenuItems[0].value!;
  }

  List<DropdownMenuItem<Highschool>> buildDropdownMenuItems(
      List<Highschool> highschools) {
    List<DropdownMenuItem<Highschool>> items = [];
    for (Highschool highschool in highschools) {
      items.add(
        DropdownMenuItem(
          value: highschool,
          child: Text(highschool.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Highschool? selectedHighschool) {
    setState(() {
      _selectedHighschool = selectedHighschool!;
    });
  }

  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    super.dispose();
  }

  //function to add border and rounded edges to our form
  OutlineInputBorder _inputformdeco() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide: const BorderSide(
          width: 1.5, color: Colors.blue, style: BorderStyle.solid),
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              content: Text(
                "Incorrect password or username.",
                textAlign: TextAlign.center,
              ),
            ));
  }

  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 16;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Spacer(),
              const Expanded(
                flex: 2,
                child: Text(
                  "Zenesus",
                  style: TextStyle(
                    fontSize: 40,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                  flex: 4,
                  child: Image.asset(
                    'assets/open-book.png',
                    height: 200,
                    width: 200,
                  )),
              const Spacer(),
              DropdownButtonFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.school),
                      enabledBorder: InputBorder.none),
                  value: _selectedHighschool,
                  items: _dropdownMenuItems,
                  onChanged: onChangeDropdownItem),
              const SizedBox(height: 20),
              Column(
                children: <Widget>[
                  TextFormField(
                      keyboardType: TextInputType.text,
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: "Enter your email",
                        enabledBorder: _inputformdeco(),
                        focusedBorder: _inputformdeco(),
                      )),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      enabledBorder: _inputformdeco(),
                      focusedBorder: _inputformdeco(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () async {
                        if (!_isLoading) {
                          _startLoading();
                        }
                        if (_selectedHighschool.id != 0 &&
                            passwordController.text != "" &&
                            usernameController.text != "") {
                          String finalSchool = "";
                          if (_selectedHighschool.id == 1) {
                            finalSchool = "Montgomery Highschool";
                          }
                          LoginConnection connection =
                              await checkLoginConnection(
                                  usernameController.text,
                                  passwordController.text,
                                  finalSchool);
                          if (connection.code == 200) {
                            writeEmailPassSchoolintoCookies(
                                usernameController.text,
                                passwordController.text,
                                finalSchool);
                            setState(() {
                              _isLoading = false;
                            });

                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CoursesPage(
                                        email: usernameController.text,
                                        password: passwordController.text,
                                        school: finalSchool,
                                      )),
                            );
                          } else if (connection.code == 401) {
                            // ignore: use_build_context_synchronously
                            setState(() {
                              _isLoading = false;
                            });
                            // ignore: use_build_context_synchronously
                            showAlert(context);
                          }
                        } else {
                          setState(() {
                            _isLoading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                content: Text(
                                  "Please make sure you selected/filled out all the fields",
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isLoading ? 'Loading... ' : 'View Grades ',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Icon(CustomIcons.binoculars, size: 22)
                          ]),
                    )),
                  ],
                ),
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TOSpage(),
                        ));
                  },
                  child: SizedBox(
                      height: 20,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "By logging in, you agree with our privacy policy",
                              style: TextStyle(fontSize: 10),
                            )
                          ]))),
            ],
          ),
        ),
      ),
    );
  }
}
