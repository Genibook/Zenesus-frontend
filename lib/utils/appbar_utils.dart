bool isBday(String bday) {
  final now = DateTime.now();
  late double month;
  late double day;

  List<String> bdays = bday.split("/");
  try {
    month = double.parse(bdays[1]);
  } catch (e) {
    month = double.parse(bdays[1][1]);
  }
  try {
    day = double.parse(bdays[0]);
  } catch (e) {
    day = double.parse(bdays[0][1]);
  }

  final bdayDay = DateTime.utc(2020, month.toInt(), day.toInt());
  //final currentlyNow = DateTime.utc(2020, now.month, now.day);
  final currentlyNow = DateTime.utc(2020, 7, 6);
  bool isBday = bdayDay.isAtSameMomentAs(currentlyNow);
  return isBday;
}
