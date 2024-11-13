import 'package:drift_frontend/http/dio_instance.dart';
import 'package:drift_frontend/route/route_utils.dart';
import 'package:drift_frontend/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  DioInstance.instance().initDio(baseUrl: "https://www.wanandroid.com");
  runApp(const MyApp());
}

// 设计尺寸
Size get designSize {
  final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
  // 逻辑短边
  final logicalShortestSide =
      firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
  // 逻辑长边
  final logicalLongestSide =
      firstView.physicalSize.longestSide / firstView.devicePixelRatio;
  // 缩放比例 designSize 越小，元素越大
  const scaleFactor = 0.95;
  // 缩放后的逻辑短边和长边
  return Size(
      logicalShortestSide * scaleFactor, logicalLongestSide * scaleFactor);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: ScreenUtilInit(
      designSize: designSize,
      builder: (context, child) {
        return MaterialApp(
          title: "Flutter Demo",
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true),
          navigatorKey: RouteUtils.navigatorKey,
          onGenerateRoute: Routes.generateRoute,
          initialRoute: RoutePath.tab,
          // home: const HomePage(),
        );
      },
    ));
  }
}
