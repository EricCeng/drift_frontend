import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

// 自定义加载显示
class Loading {
  Loading._(); // 私有构造不可被初始化

  static Future showLoading({Duration? duration}) async {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      showToastWidget(
        Container(
          color: Colors.transparent, // 底色透明
          constraints: const BoxConstraints.expand(), // 填充全屏
          child: Align(
            // 加载图形的样式
            child: Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.black54,
              ),
              // 圆形进度条
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                valueColor: const AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ),
        ),
        duration: duration ?? const Duration(days: 1), // 持续显示
        handleTouch: true,
      );
    });
  }

  static Future dismissAll() async {
    dismissAllToast();
  }
}
