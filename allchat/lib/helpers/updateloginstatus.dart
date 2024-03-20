import 'package:robochat/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateLoginStatus(bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("isLoggedIn", value);
  prefs.setString("email", emailLogin!);
}
