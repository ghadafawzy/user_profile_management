import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class SharedPreferencesHelper {
  static const String userCacheKey = 'user_cache';

  static Future<void> cacheUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(users.map((user) => user.toJson()).toList());
    await prefs.setString(userCacheKey, jsonString);
  }

  static Future<List<User>> getCachedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(userCacheKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => User.fromJson(json)).toList();
    }
    return [];
  }
}