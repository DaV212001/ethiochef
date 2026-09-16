import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../utils/constants.dart';
import 'authorization_service.dart';

class VisitorService {
  static final GetStorage _storage = GetStorage();

  static Future<void> trackVisit() async {
    try {
      // 1. Get or generate mobile_id
      String? mobileId = _storage.read('mobile_id');
      if (mobileId == null) {
        mobileId = const Uuid().v4();
        await _storage.write('mobile_id', mobileId);
      }

      // 2. Get user_id if logged in
      String? userData = await AuthService.getUserData();
      String? userId;
      if (userData != null && userData != 'none') {
        try {
          var decoded = jsonDecode(userData);
          userId = decoded['id']?.toString();
        } catch (e) {
          print('Error decoding user data for visitor tracking: $e');
        }
      }

      // 3. Prepare payload
      final String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final Map<String, dynamic> payload = {
        "date": date,
        "mobile_id": mobileId,
      };

      if (userId != null) {
        payload["user_id"] = userId;
      }

      // 4. Send request
      final response = await http.post(
        Uri.parse("${Constants.url}/user/visitor"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print("Visitor tracking response: ${response.statusCode}");
    } catch (e) {
      print("Error tracking visitor: $e");
    }
  }
}
