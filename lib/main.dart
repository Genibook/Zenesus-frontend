import 'package:flutter/material.dart';
import 'package:zenesus/screens/firstscreen.dart';
import 'package:zenesus/screens/testing.dart';
import 'package:device_preview/device_preview.dart';
import 'package:window_size/window_size.dart';
import 'package:universal_platform/universal_platform.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isWindows ||
      UniversalPlatform.isLinux ||
      UniversalPlatform.isMacOS) {
    setWindowMinSize(const Size(400, 800));
    setWindowMaxSize(Size.infinite);
  }

  runApp(
    //MyApp()
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Zenesus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: const TestingScreen(),
    );
  }
}
