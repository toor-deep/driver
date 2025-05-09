import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginState(bool isLoggedIn) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', isLoggedIn);
}
