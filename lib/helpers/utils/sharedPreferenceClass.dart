// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? sharedPrefs;

  Future<void> init() async {
    sharedPrefs = await SharedPreferences.getInstance();
  }

  String get token => sharedPrefs!.getString(keyToken) ?? "";

  bool getIsUnBoarded() {
    return sharedPrefs!.getBool(keyUnBoarded) ?? false;
  }
  bool getSignedIn() {
    return sharedPrefs!.getBool(keySignedIn) ?? false;
  }
  settoken(String value) {
    sharedPrefs!.setString(keyToken, value);
  }

  setSignedIn(bool value) {
    sharedPrefs!.setBool(keySignedIn, value);
  }

  setIsUnBoarded(bool value) {
    sharedPrefs!.setBool(keyUnBoarded, value);
  }

  void removeToken() {
    sharedPrefs!.remove(keyToken);
  }
}

final sharedPrefs = SharedPrefs();

// constants/strings.dart
String keyToken = "key_token";
String keyUnBoarded = "key_unBoarded";
String keySignedIn = "key_signedIn";
