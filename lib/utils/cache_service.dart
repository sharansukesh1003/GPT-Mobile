import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static Future<String?> getOpenAIAPIKey({required String key}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(key);
  }

  static Future<void> setOpenAIAPIKey({required String apiKey}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString("apiKey", apiKey);
  }

  static Future<void> updateAPIKey({required String newKey}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.remove("apiKey");
    await sharedPreferences.setString("apiKey", newKey);
  }
}
