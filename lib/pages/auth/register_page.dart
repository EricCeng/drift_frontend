import 'package:drift_frontend/common_ui/common_style.dart';
import 'package:drift_frontend/pages/auth/auth_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        backgroundColor: Colors.teal,
        body: Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          alignment: Alignment.center,
          child: Consumer<AuthViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonInput(
                      labelText: "请输入用户名",
                      onChanged: (value) {
                        viewModel.registerInfo.userName = value;
                      }),
                  SizedBox(height: 20.h),
                  commonInput(
                      labelText: "请输入密码",
                      onChanged: (value) {
                        viewModel.registerInfo.password = value;
                      },
                      obscureText: true),
                  SizedBox(height: 20.h),
                  commonInput(
                      labelText: "请再次输入密码",
                      onChanged: (value) {
                        viewModel.registerInfo.rePassword = value;
                      },
                      obscureText: true),
                  SizedBox(height: 50.h),
                  whiteBorderButton(
                      title: "注册",
                      onTap: () {
                        viewModel.register().then((value) {
                          if (value == true) {
                            showToast("注册成功");
                            Navigator.pop(context);
                          }
                        });
                      })
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
