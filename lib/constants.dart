class Constants {
  Constants._();

  static String? url = const String.fromEnvironment('URL',
      defaultValue: 'http://192.168.0.224:5000');
}
