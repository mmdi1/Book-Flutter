import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  static clearAll() async {
    print("清空所有本地缓存数据.....");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  /*
   * 利用SharedPreferences存储数据
   */
  static Future setValue(String key, String val) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, val);
  }

  static Future<String> getValue(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key);
  }

  static Future setInt(String key, int val) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(key, val);
  }

  static Future<int> getInt(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getInt(key);
  }

  static Future setBool(String key, bool val) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(key, val);
  }

  static Future<bool> getBool(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(key);
  }
}
