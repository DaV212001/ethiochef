import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<String?> getAuthorizationToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token =
        sharedPreferences.getString('ethioChef_authorization_token') ?? 'none';
    Logger().d(token);
    return token;
    // return storage.read(key: 'ethioChef_authorization_token');
  }

  static Future<void> setAuthorizationToken(String authorizationToken) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        'ethioChef_authorization_token', authorizationToken);
    // await storage.write(key: 'ethioChef_authorization_token', value: authorizationToken);
  }

  static Future<void> logout() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("ethioChef_authorization_token");
    // await storage.delete(key: 'ethioChef_authorization_token');
  }

  static Future<bool> isUserLoggedIn() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token =
        sharedPreferences.getString('ethioChef_authorization_token') ?? 'none';
    if (token == "none") {
      return false;
    }
    return true;
    // print("isUserLoggedIn");
    // return storage.containsKey(key: 'ethioChef_authorization_token');
  }

  static Future<void> setRefreshToken(String refreshToken) async {
    await storage.write(key: 'ethioChef_refresh_token', value: refreshToken);
  }

  static Future<String?> getRefreshToken() async {
    return await storage.read(key: 'ethioChef_refresh_token');
  }
}
