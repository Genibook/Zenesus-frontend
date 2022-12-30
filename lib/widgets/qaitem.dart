import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QAItem extends StatelessWidget {
  QAItem({
    Key? key,
    required this.title,
    required this.children,
    this.color,
  }) : super(key: key);

  final Widget title;
  Color? color;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: color,
      title: title,
      children: children,
    );
  }
}
