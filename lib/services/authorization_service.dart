import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<String?> getAuthorizationToken() async {
    return await storage.read(key: 'ethioChef_authorization_token');
  }

  static Future<void> setAuthorizationToken(String authorizationToken) async {
    await storage.write(key: 'ethioChef_authorization_token', value: authorizationToken);
  }

  static Future<void> logout() async {
    await storage.delete(key: 'ethioChef_authorization_token');
  }

  static Future<bool> isUserLoggedIn() async{
    return storage.containsKey(key: 'ethioChef_authorization_token');
  }

  static Future<void> setRefreshToken(String refreshToken) async {
    await storage.write(key: 'ethioChef_refresh_token', value: refreshToken);
  }

  static Future<String?> getRefreshToken() async {
    return await storage.read(key: 'ethioChef_refresh_token');
  }
}
