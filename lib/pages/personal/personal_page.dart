import 'package:drift_frontend/pages/about/about_page.dart';
import 'package:drift_frontend/pages/auth/login_page.dart';
import 'package:drift_frontend/pages/collects/colllects_page.dart';
import 'package:drift_frontend/pages/personal/personal_vm.dart';
import 'package:drift_frontend/route/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PersonalPage();
  }
}

class _PersonalPage extends State<PersonalPage> {
  PersonViewModel viewModel = PersonViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.initData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            _header(() {
              if (viewModel.shouldLogin) {
                RouteUtils.push(context, const LoginPage());
              }
            }),
            _settingsItem("我的收藏", () {
              RouteUtils.push(context, const CollectsPage());
            }),
            _settingsItem("检查更新", () {}),
            _settingsItem("关于我们", () {
              RouteUtils.push(context, const AboutPage());
            }),
            Consumer<PersonViewModel>(builder: (context, viewModel, child) {
              if (viewModel.shouldLogin) {
                return const SizedBox();
              }
              return _settingsItem("退出登录", () {
                viewModel.logout((value) {
                  if (value == true) {
                    RouteUtils.pushAndRemoveUntil(context, const LoginPage());
                  }
                });
              });
            }),
          ],
        )),
      ),
    );
  }

  Widget _header(GestureTapCallback? onTap) {
    return Container(
      color: Colors.teal,
      width: double.infinity,
      height: 200.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(35.r),
          //   child: Image.asset(
          //     "assets/images/default_avatar.jpg",
          //     width: 80.r,
          //     height: 80,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              backgroundImage:
                  const AssetImage("assets/images/default_user_avatar.jpg"),
              radius: 35.r,
            ),
          ),
          SizedBox(
            height: 6.h,
          ),
          Consumer<PersonViewModel>(builder: (context, viewModel, child) {
            return GestureDetector(
              onTap: onTap,
              child: Text(
                viewModel.username ?? "",
                style: TextStyle(fontSize: 13.sp, color: Colors.white),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _settingsItem(String? title, GestureTapCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 45.h,
        margin: EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w),
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5.r),
            borderRadius: BorderRadius.circular(5.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title ?? "", style: TextStyle(fontSize: 14.sp)),
            // Expanded(child: SizedBox()),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.black26)
          ],
        ),
      ),
    );
  }
}
