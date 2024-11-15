import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PersonalPage();
  }
}

class _PersonalPage extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          _header(),
          _settingsItem("我的收藏", () {}),
          _settingsItem("检查更新", () {}),
          _settingsItem("关于我们", () {})
        ],
      )),
    );
  }

  Widget _header() {
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
          CircleAvatar(
            backgroundImage:
                AssetImage("assets/images/default_user_avatar.jpg"),
            radius: 35.r,
          ),
          SizedBox(
            height: 6.h,
          ),
          Text("未登录", style: TextStyle(fontSize: 13.sp, color: Colors.white)),
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
