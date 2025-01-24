import 'package:drift_frontend/pages/auth/register_page.dart';
import 'package:drift_frontend/pages/tab_page.dart';
import 'package:drift_frontend/route/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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

  late bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    phoneNumberInputController = TextEditingController();
    phoneNumberInputController?.addListener(() {
      setState(() {});
    });
    pwdInputController = TextEditingController();
    pwdInputController?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 25.w, right: 25.w),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "DRIFT",
                  style: GoogleFonts.leckerliOne(
                    color: Colors.deepPurple[200],
                    fontSize: 80.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              commonInput(
                prefixIcon: Icon(
                  PhosphorIconsRegular.phone,
                  color: Colors.deepPurple[200],
                ),
                hintText: "请输入手机号",
                controller: phoneNumberInputController,
                suffixIcon: phoneNumberInputController!.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          phoneNumberInputController?.clear();
                          setState(() {});
                        },
                        icon: Icon(
                          PhosphorIconsFill.xCircle,
                          color: Colors.deepPurple[100],
                        ),
                      )
                    : null,
              ),
              SizedBox(height: 20.h),
              commonInput(
                prefixIcon: Icon(
                  PhosphorIconsRegular.lockSimple,
                  color: Colors.deepPurple[200],
                ),
                hintText: "请输入密码",
                controller: pwdInputController,
                isObscured: _isObscured,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (pwdInputController!.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          pwdInputController?.clear();
                          setState(() {});
                        },
                        icon: Icon(
                          PhosphorIconsFill.xCircle,
                          color: Colors.deepPurple[100],
                        ),
                      ),
                    // SizedBox(width: 5.w),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      icon: Icon(
                        _isObscured
                            ? PhosphorIconsFill.eyeSlash
                            : PhosphorIconsFill.eye,
                        color: Colors.deepPurple[200],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    "忘记密码？",
                    style: TextStyle(
                        color: Colors.deepPurple[300], fontSize: 14.sp),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              commonBorderButton(
                title: "登录",
                onTap: () {
                  viewModel.setLoginInfo(
                      phoneNumber: phoneNumberInputController?.text,
                      password: pwdInputController?.text);
                  viewModel.login().then((value) {
                    if (value == true) {
                      RouteUtils.pushAndRemoveUntil(context, const TabPage());
                    }
                  });
                },
                isEnable: phoneNumberInputController!.text.isNotEmpty &&
                    pwdInputController!.text.isNotEmpty,
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "没有账号？",
                    style: TextStyle(color: Colors.black54, fontSize: 14.sp),
                  ),
                  GestureDetector(
                    onTap: () {
                      RouteUtils.push(context, const RegisterPage());
                    },
                    child: Text(
                      "立即注册",
                      style: TextStyle(
                          color: Colors.deepPurple[300], fontSize: 14.sp),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
