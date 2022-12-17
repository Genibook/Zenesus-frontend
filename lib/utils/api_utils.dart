import 'package:flutter/material.dart';
import "package:zenesus/constants.dart";
import 'package:zenesus/widgets/apitest.dart';

Uri getCorrectUri(String ending) {
  Uri url;
  if (Constants.url.startsWith("192")) {
    url = Uri.http(Constants.url, ending);
  } else {
    //url is https
    url = Uri.https(Constants.url, ending);
  }

  return url;
}

Widget apiRowLogic(dynamic widget, dynamic context) {
  if (TEST_DATA && SHOWOFF) {
    return const SizedBox();
  } else if (TEST_DATA) {
    return apitestingrow(widget, context);
  } else {
    return const SizedBox();
  }
}
