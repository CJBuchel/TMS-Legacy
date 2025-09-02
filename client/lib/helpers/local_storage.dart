import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferencesWithCache _gls;

Future<void> initializeLocalStorage() async {
  _gls = await SharedPreferencesWithCache.create(
    cacheOptions: SharedPreferencesWithCacheOptions(),
  );
}

SharedPreferencesWithCache get localStorage => _gls;
