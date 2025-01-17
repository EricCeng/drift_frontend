import 'package:drift_frontend/pages/auth/register_page.dart';
import 'package:drift_frontend/pages/tab_page.dart';
import 'package:drift_frontend/route/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../common_ui/common_style.dart';
import 'auth_vm.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  AuthViewModel viewModel = AuthViewModel();

  TextEditingController? phoneNumberInputController;
  TextEditingController? pwdInputController;

  @override
  void initState() {
    super.initState();
    phoneNumberInputController = TextEditingController();
    pwdInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: Container(
          color: Colors.teal,
          padding: EdgeInsets.only(left: 25.w, right: 25.w),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              commonInput(
                hintText: "请输入手机号",
                controller: phoneNumberInputController,
              ),
              SizedBox(height: 20.h),
              commonInput(
                hintText: "请输入密码",
                controller: pwdInputController,
                obscureText: true,
              ),
              SizedBox(height: 50.h),
              whiteBorderButton(
                  title: "登录",
                  onTap: () {
                    viewModel.setLoginInfo(
                        username: phoneNumberInputController?.text,
                        password: pwdInputController?.text);
                    viewModel.login().then((value) {
                      if (value == true) {
                        RouteUtils.pushAndRemoveUntil(context, TabPage());
                      }
                    });
                  }),
              SizedBox(height: 5.h),
              registerButton(() {
                RouteUtils.push(context, RegisterPage());
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget registerButton(GestureTapCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 100.w,
        height: 45.h,
        child: Text(
          "注册",
          style: TextStyle(color: Colors.white, fontSize: 13.sp),
        ),
      ),
    );
  }
}
