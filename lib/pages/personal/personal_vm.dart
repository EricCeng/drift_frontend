import 'package:drift_frontend/constants.dart';
import 'package:drift_frontend/repository/api.dart';
import 'package:drift_frontend/utils/sp_utils.dart';
import 'package:flutter/material.dart';

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
}
