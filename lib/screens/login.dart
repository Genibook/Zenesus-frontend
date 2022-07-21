import 'package:flutter/material.dart';
import 'package:zenesus/screens/courses.dart';
import 'package:zenesus/widgets/appbar.dart';

class Highschool{
  late int id;
  late String name;

  Highschool(this.id, this.name);

  static List<Highschool> getHighschools(){
    return <Highschool>[
      Highschool(0, "Select a School District"),
      Highschool(1, "Montgomery")
    ];
  }


}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key, required this.incorrect}) : super(key: key);
  final bool incorrect;

  @override
  State<MyLoginPage> createState() => _Login();
}


class _Login extends State<MyLoginPage> {
  late bool _passwordVisible = false;

  final List<Highschool> _highschools = Highschool.getHighschools();
  late List<DropdownMenuItem<Highschool>> _dropdownMenuItems;
  late Highschool _selectedHighschool;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_highschools);
    _selectedHighschool = _dropdownMenuItems[0].value!;
    super.initState();

  }

  List<DropdownMenuItem<Highschool>> buildDropdownMenuItems(List<Highschool> highschools) {
    List<DropdownMenuItem<Highschool>> items = [];
    for (Highschool highschool in highschools){
      items.add(
        DropdownMenuItem(
          value: highschool,
          child: Text(highschool.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Highschool? selectedHighschool){
    setState((){
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
  OutlineInputBorder _inputformdeco(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0),
      borderSide:
      BorderSide(width: 1.5, color: Colors.blue, style: BorderStyle.solid),
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) =>
        const AlertDialog(
          content: Text(
            "Incorrect password or username.",
            textAlign: TextAlign.center,
          ),

        ));
  }
  @override
  Widget build(BuildContext context) {
    if(widget.incorrect){
      Future.delayed(Duration.zero, () => showAlert(context));
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            LoginAppBar(),
            Expanded(
                flex: 3,
                child:Image.asset('assets/open-book.png',
                  height: 225,
                  width: 225,
                )
            ),

            DropdownButtonFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.school),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                    )
                ),
                value: _selectedHighschool,
                items: _dropdownMenuItems,
                onChanged: onChangeDropdownItem
            ),

            const SizedBox(height:20),
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
                    )
                ),
                const SizedBox(height:10),
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

            const SizedBox(height:20),
            ElevatedButton(
              onPressed: () async {

                if (_selectedHighschool.id !=0 && passwordController.text != "" && usernameController.text != ""){
                  String finalSchool = "";
                  if (_selectedHighschool.id == 1){
                    finalSchool = "Montgomery Highschool";
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Courses(email:usernameController.text, password: passwordController.text,school: finalSchool,)),
                  );


                }else{
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
              child: const Text('Sign In'),
            ),
            const Spacer(flex:1),
          ],

        ),


      ),
    );
  }

  _fetchPrefs() async {
    await Future.delayed(const Duration(seconds: 10));

  }

}