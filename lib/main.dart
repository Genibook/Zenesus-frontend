import 'dart:io';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:device_preview/device_preview.dart';
import 'package:window_size/window_size.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:zenesus/screens/firstscreen.dart';
import 'package:material_you_colours/material_you_colours.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isWindows ||
      UniversalPlatform.isLinux ||
      UniversalPlatform.isMacOS) {
    setWindowMinSize(const Size(300, 600));
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
    return FutureBuilder(
        future: getMaterialYouColours(),
        builder: (context, AsyncSnapshot<MaterialYouPalette?> snapshot) {
          final primarySwatch = snapshot.data?.accent1 ?? Colors.blue;
          return MaterialApp(
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate
            ],
            title: 'Zenesus',
            theme: ThemeData(
              useMaterial3: true,
              primarySwatch: primarySwatch,
            ),
            darkTheme: ThemeData.dark(
              useMaterial3: true,
            ),
            home: const FirstScreen(),
          );
        });
  }
}
