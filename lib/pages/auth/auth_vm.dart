import 'package:drift_frontend/constants.dart';
import 'package:drift_frontend/repository/api.dart';
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
    if (registerInfo.password != registerInfo.rePassword) {
      showToast("两次密码必须一致！");
      return false;
    }
    if ((registerInfo.password?.length ?? 0) < 6) {
      showToast("密码长度不能小于6位！");
      return false;
    }
    dynamic callback = await Api.instance.register(
        phoneNumber: registerInfo.phoneNumber,
        password: registerInfo.password,
        rePassword: registerInfo.rePassword);
    if (callback is bool) {
      return callback;
    } else {
      return true;
    }
  }

  Future<bool?> login() async {
    dynamic token = await Api.instance.login(
        phoneNumber: loginInfo.phoneNumber, password: loginInfo.password);
    if (token != null) {
      // 保存访问令牌
      SpUtils.saveString(Constants.SP_ACCESS_TOKEN, token);
      return true;
    }
    showToast("登录失败！");
    return false;
  }

  void setLoginInfo({String? phoneNumber, String? password}) {
    if (phoneNumber != null) {
      loginInfo.phoneNumber = phoneNumber;
    }
    if (password != null) {
      loginInfo.password = password;
    }
  }

  void setRegisterInfo(
      {String? phoneNumber, String? password, String? rePassword}) {
    if (phoneNumber != null) {
      registerInfo.phoneNumber = phoneNumber;
    }
    if (password != null) {
      registerInfo.password = password;
    }
    if (rePassword != null) {
      registerInfo.rePassword = rePassword;
    }
  }
}

class RegisterInfo {
  String? phoneNumber;
  String? password;
  String? rePassword;
}

class LoginInfo {
  String? phoneNumber;
  String? password;
}
