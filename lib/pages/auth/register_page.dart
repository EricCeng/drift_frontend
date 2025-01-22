import 'package:drift_frontend/common_ui/common_style.dart';
import 'package:drift_frontend/pages/auth/auth_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  AuthViewModel viewModel = AuthViewModel();

  TextEditingController? phoneNumberInputController;
  TextEditingController? pwdInputController;
  TextEditingController? rePwdInputController;

  late bool _isObscuredForPwd = true;
  late bool _isObscuredForRePwd = true;

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
    rePwdInputController = TextEditingController();
    rePwdInputController?.addListener(() {
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.left_chevron,
              color: Colors.deepPurple[200],
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 25.w, right: 25.w),
          alignment: Alignment.topCenter,
          child: Consumer<AuthViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "注册",
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[300],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
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
                    isObscured: _isObscuredForPwd,
                    controller: pwdInputController,
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
                              _isObscuredForPwd = !_isObscuredForPwd;
                            });
                          },
                          icon: Icon(
                            _isObscuredForPwd
                                ? PhosphorIconsFill.eyeSlash
                                : PhosphorIconsFill.eye,
                            color: Colors.deepPurple[200],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  commonInput(
                    prefixIcon: Icon(
                      PhosphorIconsRegular.lockSimple,
                      color: Colors.deepPurple[200],
                    ),
                    hintText: "请再次输入密码",
                    isObscured: _isObscuredForRePwd,
                    controller: rePwdInputController,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (rePwdInputController!.text.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              rePwdInputController?.clear();
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
                              _isObscuredForRePwd = !_isObscuredForRePwd;
                            });
                          },
                          icon: Icon(
                            _isObscuredForRePwd
                                ? PhosphorIconsFill.eyeSlash
                                : PhosphorIconsFill.eye,
                            color: Colors.deepPurple[200],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.h),
                  commonBorderButton(
                    title: "注册",
                    onTap: () {
                      viewModel.setRegisterInfo(
                        phoneNumber: phoneNumberInputController?.text,
                        password: pwdInputController?.text,
                        rePassword: rePwdInputController?.text,
                      );
                      viewModel.register().then((value) {
                        if (value == true) {
                          showToast("注册成功！");
                          Navigator.pop(context);
                        }
                      });
                    },
                    isEnable: phoneNumberInputController!.text.isNotEmpty &&
                        pwdInputController!.text.isNotEmpty &&
                        rePwdInputController!.text.isNotEmpty,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
