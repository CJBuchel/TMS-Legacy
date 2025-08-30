import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _gls;

Future<void> initializeLocalStorage() async {
  _gls = await SharedPreferences.getInstance();
}

SharedPreferences get localStorage => _gls;
