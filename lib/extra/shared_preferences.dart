import 'package:shared_preferences/shared_preferences.dart';
import 'app_constants.dart';
import 'app_variables.dart';

class AppPreferences {
  static AppPreferences shared = AppPreferences();
  SharedPreferences? _prefs;

  initialisePrefs() async {
    _prefs = await SharedPreferences.getInstance();
    isLoggedIn = await getBoolSharedPreferences(AppConstants.alreadyLogin);

    if (await getSharedPreferences(AppConstants.accessTokenKey) != null) {
      accessToken =
          "${await getSharedPreferences(AppConstants.accessTokenKey)}";
    }
  }

  /// Saves the JWT returned by /auth/login or /auth/register.
  Future<void> saveLogin(String token) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString(AppConstants.accessTokenKey, token);
    await _prefs?.setBool(AppConstants.alreadyLogin, true);
    accessToken = token;
    isLoggedIn = true;
  }

  Future<void> clearLogin() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.remove(AppConstants.accessTokenKey);
    await _prefs?.remove(AppConstants.user);
    await _prefs?.setBool(AppConstants.alreadyLogin, false);
    accessToken = '';
    isLoggedIn = false;
  }

  removeUser() async {
    if (_prefs == null) initialisePrefs();
    await _prefs?.remove(AppConstants.user);
  }

  saveSharedPreferences(String key, String value) {
    if (_prefs == null) initialisePrefs();
    _prefs?.setString(key, value);
  }

  removePreferences(String key) {
    if (_prefs == null) initialisePrefs();
    _prefs?.remove(key);
  }

  saveBoolSharedPreferences(String key, bool value) {
    if (_prefs == null) initialisePrefs();
    _prefs?.setBool(key, value);
  }

  getSharedPreferences(String key) {
    if (_prefs == null) initialisePrefs();
    return _prefs?.getString(key);
  }

  getBoolSharedPreferences(String key) {
    if (_prefs == null) initialisePrefs();
    return _prefs?.getBool(key) ?? false;
  }
}
