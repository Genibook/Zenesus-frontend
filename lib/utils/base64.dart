import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}

ImageProvider<Object>? createImageFromImage64(dynamic snapshot) {
  if (snapshot.data!.image64 != "N/A") {
    return imageFromBase64String(snapshot.data!.image64).image;
  }

  return const AssetImage("assets/user.png");
}
