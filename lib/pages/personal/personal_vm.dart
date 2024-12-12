import 'package:drift_frontend/constants.dart';
import 'package:drift_frontend/repository/api.dart';
import 'package:drift_frontend/repository/data/app_check_update_data.dart';
import 'package:drift_frontend/utils/sp_utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonViewModel with ChangeNotifier {
  String? username;
  bool shouldLogin = false;

  Future initData() async {
    SpUtils.getString(Constants.SP_USER_NAME).then((value) {
      if (value == null || value == "") {
        username = "未登录";
        shouldLogin = true;
      } else {
        username = value;
        shouldLogin = false;
      }
      notifyListeners();
    });
  }

  Future logout(ValueChanged<bool> callback) async {
    bool? success = await Api.instance.logout();
    if (success == true) {
      SpUtils.removeAll();
      callback.call(true);
    } else {
      callback.call(false);
    }
  }

  Future<String?> checkUpdate() async {
    var packageInfo = await PackageInfo.fromPlatform();
    String currentVersionCode = packageInfo.buildNumber;
    AppCheckUpdateData? data = await Api.instance.checkAppUpdate();
    String onlineVersionCode = data?.data?.buildVersionNo ?? "0";
    if ((int.tryParse(currentVersionCode) ?? 0) <
        (int.tryParse(onlineVersionCode) ?? 0)) {
      SpUtils.saveString(Constants.SP_NEW_APP_VERSION, onlineVersionCode);
      return data?.data?.downloadURL;
    } else {
      SpUtils.saveString(Constants.SP_NEW_APP_VERSION, currentVersionCode);
      return null;
    }
  }

  Future jumpToOutLink(String? url) async {
    final uri = Uri.parse(url ?? "");
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri);
    }
    return null;
  }
}
