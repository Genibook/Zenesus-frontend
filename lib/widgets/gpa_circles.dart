import 'package:flutter/material.dart';
import 'package:zenesus/utils/gpa_utils.dart';
import 'dart:math';

Widget unweightedCircle(BuildContext context, dynamic snapshot) {
  const double size = 200;
  const double twoPi = pi * 2;
  List<double> averages = snapshot.data!.getGpas();
  var brightness = MediaQuery.of(context).platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  return SizedBox(
      width: size,
      height: size,
      child: Stack(children: [
        ShaderMask(
          shaderCallback: (rect) {
            return SweepGradient(
                startAngle: 0,
                endAngle: twoPi,
                stops: [averages[0] / 100, averages[0] / 100],
                // 0.0, 0.5, 0.5, 1.0
                center: Alignment.center,
                colors: [
                  getColorFromGrade(averages[0]),
                  Colors.grey.withAlpha(55)
                ]).createShader(rect);
          },
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
          ),
        ),
        Center(
          child: Container(
            height: size - 40,
            width: size - 40,
            decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color.fromARGB(255, 48, 48, 48)
                    : Colors.white,
                shape: BoxShape.circle),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  const Text("Unweighted GPA",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Text("${roundDouble(averages[0], 2)}%",
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                  const Text("tap me to change modes",
                      style: TextStyle(fontSize: 9)),
                  const SizedBox(height: 1.5),
                  const Text("pull down to refresh",
                      style: TextStyle(fontSize: 8)),
                ])),
          ),
        )
      ]));
}

Widget weightedCircle(BuildContext context, dynamic snapshot) {
  const double size = 200;
  const double twoPi = pi * 2;

  List<double> averages = snapshot.data!.getGpas();
  var brightness = MediaQuery.of(context).platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  return SizedBox(
      width: size,
      height: size,
      child: Stack(children: [
        ShaderMask(
          shaderCallback: (rect) {
            return SweepGradient(
                startAngle: 0,
                endAngle: twoPi,
                stops: [averages[1] / 100, averages[1] / 100],
                // 0.0, 0.5, 0.5, 1.0
                center: Alignment.center,
                colors: [
                  getColorFromGrade(averages[1]),
                  Colors.grey.withAlpha(55)
                ]).createShader(rect);
          },
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
          ),
        ),
        Center(
          child: Container(
            height: size - 40,
            width: size - 40,
            decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color.fromARGB(255, 48, 48, 48)
                    : Colors.white,
                shape: BoxShape.circle),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  const Text("Weighted GPA",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("${roundDouble(averages[1], 2)}%",
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                  const Text("tap me to change modes",
                      style: TextStyle(fontSize: 9)),
                  const SizedBox(height: 1.5),
                  const Text("pull down to refresh",
                      style: TextStyle(fontSize: 8)),
                ])),
          ),
        )
      ]));
}
