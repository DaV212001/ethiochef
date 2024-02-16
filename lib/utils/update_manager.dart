import 'dart:convert';
import 'dart:io' show Platform;
import 'package:ethio_chef/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quickalert/quickalert.dart';

import 'package:url_launcher/url_launcher.dart';

import '../models/update_manager_model.dart';
import '../widgets/update_card.dart';

class UpdateManager {
  static final int statusNoUpdate = 0;
  static final int statusUpdate = 1;
  static final int statusRequiredUpdate = 2;
  static bool popUpShowed = false;
  late String url = "";

  Future<int> checkForUpdate() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final response = await http.get(
          Uri.parse('${Constants.url}/user/app-version/latest'));
      print(response.body);
      print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception(response.statusCode.toString());
      }
      final jsonData = json.decode(response.body)["data"][0];
      print(jsonData);
      print(jsonData["latest_version_android"]);
      print(jsonData["minimum_version_android"]);
      //todo get form api
      final updateInfoJson = {
        'latest_version_android': jsonData["latest_version_android"],
        'minimum_version_android': jsonData["minimum_version_android"],
        "update_link_android": "https://play.google.com/store/apps/details?id=co.digitalmerkato",
        'latest_version_ios': jsonData["latest_version_ios"],
        'minimum_version_ios': jsonData["minimum_version_ios"],
        "update_link_ios": ""
      };

      print(updateInfoJson.toString());

      String platform = "";
      if (Platform.isAndroid) {
        platform = "android";
        url = updateInfoJson["update_link_android"];
      } else if (Platform.isIOS) {
        platform = "ios";
        url = updateInfoJson["update_link_ios"];
      }
      String installedVersion = packageInfo.version;
      String latestVersion =
      updateInfoJson['latest_version_$platform'].toString();
      String minimumVersion =
      updateInfoJson['minimum_version_$platform'].toString();

      if (installedVersion == latestVersion) {
        return statusNoUpdate;
      } else if (isVersionNewer(installedVersion, minimumVersion)) {
        return statusRequiredUpdate;
      } else if (isVersionNewer(installedVersion, latestVersion)) {
        return statusUpdate;
      }
    } catch (e) {
      rethrow;
    }
    return statusNoUpdate;
  }

  void showUpdateDialog(BuildContext context) async {
    if (popUpShowed) {
      return;
    }
    int updateStatus = await checkForUpdate();
    if (updateStatus == statusNoUpdate) {
      return;
    }
    bool requiredUpdate = updateStatus == statusRequiredUpdate;
    popUpShowed = true;
    showDialog(
      context: context,
      barrierDismissible: !requiredUpdate,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            if (requiredUpdate) {
              SystemNavigator.pop();
            }
            return !requiredUpdate;
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            backgroundColor: Theme
                .of(context)
                .cardColor,
            child: UpdateCard(
                isRequired: requiredUpdate,
                uri: Uri.parse(url)
            )
          ),
        );
      },
    );
  }

  bool isVersionNewer(String currentVersion, String newVersion) {

    final List<int> current = currentVersion.split('.').map(int.parse).toList();
    final List<int> newer = newVersion.split('.').map(int.parse).toList();

    // Compare version components
    for (int i = 0; i < current.length && i < newer.length; i++) {
      if (current[i] < newer[i]) {
        return true; // Second version is newer
      } else if (current[i] > newer[i]) {
        return false; // Second version is not newer
      }
    }
    return current.length < newer.length;
  }
  Future<void> _launchUrl() async {
    String url = "https://play.google.com/store/apps/details?id=com.peacetechnology.ethiochef";
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
