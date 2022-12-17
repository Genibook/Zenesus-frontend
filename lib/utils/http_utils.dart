import "package:zenesus/constants.dart";

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
