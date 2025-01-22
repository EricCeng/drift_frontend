import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 标题文本 15 号
TextStyle titleTextStyle15 = TextStyle(color: Colors.black, fontSize: 15.sp);

// 普通字体，只做判空处理
Text normalText(String? text) {
  return Text(text ?? "", style: titleTextStyle15);
}

// 通用输入框
Widget commonInput({
  Icon? prefixIcon,
  String? hintText,
  String? labelText,
  TextEditingController? controller,
  ValueChanged<String>? onChanged,
  bool? isObscured,
  Widget? suffixIcon,
  VoidCallback? onPressed,
}) {
  return TextField(
    controller: controller,
    onChanged: onChanged,
    style: TextStyle(color: Colors.black, fontSize: 16.sp),
    // 光标颜色
    cursorColor: Colors.deepPurple[200],
    // 密文显示
    obscureText: isObscured ?? false,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black26, fontSize: 16.sp),
      filled: true,
      fillColor: Colors.grey[100],
      floatingLabelBehavior: FloatingLabelBehavior.never,
      // 未获取焦点前的边框样式
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.r),
        borderRadius: BorderRadius.circular(50),
      ),
      // 获取焦点后的边框样式
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.r),
        borderRadius: BorderRadius.circular(50),
      ),
      suffixIcon: suffixIcon,
    ),
  );
}

Widget commonBorderButton({
  required String title,
  GestureTapCallback? onTap,
  required bool isEnable,
}) {
  return GestureDetector(
    onTap: isEnable ? onTap : null,
    child: Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50.h,
      margin: EdgeInsets.only(left: 25.w, right: 25.w),
      decoration: BoxDecoration(
          color: isEnable ? Colors.deepPurple[200] : Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(22.5.r)),
          border: Border.all(color: Colors.white, width: 1.r)),
      child: Text(
        title,
        style: TextStyle(
            color: isEnable ? Colors.white : Colors.grey[500], fontSize: 16.sp),
      ),
    ),
  );
}
