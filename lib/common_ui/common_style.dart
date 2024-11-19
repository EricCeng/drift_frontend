import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 标题文本 15 号
TextStyle titleTextStyle15 = TextStyle(color: Colors.black, fontSize: 15.sp);

// 普通字体，只做判空处理
Text normalText(String? text) {
  return Text(text ?? "", style: titleTextStyle15);
}

// 通用输入框
Widget commonInput(
    {String? labelText,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    bool? obscureText}) {
  return TextField(
    // onChanged: (value) {
    //   input = value;
    // },
    controller: controller,
    onChanged: onChanged,
    style: TextStyle(color: Colors.white, fontSize: 14.sp),
    // 光标颜色
    cursorColor: Colors.white,
    // 密文显示
    obscureText: obscureText ?? false,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.white),
      // 未获取焦点前的边框样式
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.r)),
      // 获取焦点后的边框样式
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.r)),
    ),
  );
}

// 白色边框按钮
Widget whiteBorderButton({required String title, GestureTapCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 45.h,
      margin: EdgeInsets.only(left: 40.w, right: 40.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(22.5.r)),
          border: Border.all(color: Colors.white, width: 1.r)),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 15.sp),
      ),
    ),
  );
}
