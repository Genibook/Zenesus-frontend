import 'package:flutter/material.dart';
import 'package:zenesus/screens/LoginGrades.dart';
import 'package:zenesus/screens/testing.dart';
import 'package:device_preview/device_preview.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,

      title: 'Zenesus',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      darkTheme:ThemeData.dark(),
      home: const TestingScreen(),
    );
  }
}


