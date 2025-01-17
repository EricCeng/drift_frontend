import 'package:drift_frontend/constants.dart';
import 'package:drift_frontend/repository/api.dart';
import 'package:drift_frontend/repository/data/user_info_data.dart';
import 'package:drift_frontend/utils/sp_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';

class AuthViewModel extends ChangeNotifier {
  RegisterInfo registerInfo = RegisterInfo();
  LoginInfo loginInfo = LoginInfo();

  Future<void> check() async {
    await Api.instance.check();
  }

  Future<bool?> register() async {
    if (registerInfo.userName != null &&
        registerInfo.password != null &&
        registerInfo.rePassword != null &&
        registerInfo.password == registerInfo.rePassword) {
      if ((registerInfo.password?.length ?? 0) >= 6) {
        dynamic callback = await Api.instance.register(
            username: registerInfo.userName,
            password: registerInfo.password,
            rePassword: registerInfo.rePassword);
        if (callback is bool) {
          return callback;
        } else {
          return true;
        }
      }
      showToast("密码长度不能小于6位");
      return false;
    }
    showToast("输入不能为空或密码必须一致");
    return false;
  }

  Future<bool?> login() async {
    if (loginInfo.userName != null && loginInfo.password != null) {
      UserInfoData data = await Api.instance
          .login(username: loginInfo.userName, password: loginInfo.password);
      if (data.username != null && data.username?.isNotEmpty == true) {
        // 保存用户名
        SpUtils.saveString(Constants.SP_USER_NAME, data.username ?? "");
        return true;
      }
      showToast("登录失败");
      return false;
    }
    showToast("输入不能为空");
    return false;
  }

  void setLoginInfo({String? username, String? password}) {
    if (username != null) {
      loginInfo.userName = username;
    }
    if (password != null) {
      loginInfo.password = password;
    }
  }
}

class RegisterInfo {
  String? userName;
  String? password;
  String? rePassword;
}

class LoginInfo {
  String? userName;
  String? password;
}
