// 路由管理类
import 'package:drift_frontend/common_ui/web/webview_widget.dart';
import 'package:drift_frontend/pages/about/about_page.dart';
import 'package:drift_frontend/pages/splash_screen.dart';
import 'package:drift_frontend/pages/tab_page.dart';
import 'package:flutter/material.dart';

import '../common_ui/web/webview_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.splash:
        return pageRoute(const SplashScreen(), settings: settings);
      case RoutePath.tab:
        return pageRoute(const TabPage(), settings: settings);
      case RoutePath.webViewPage:
        return pageRoute(
            WebViewPage(
              loadResource: "",
              webViewType: WebViewType.URL,
            ),
            settings: settings);
      case RoutePath.loginPage:
        return pageRoute(const LoginPage(), settings: settings);
      case RoutePath.registerPage:
        return pageRoute(const RegisterPage(), settings: settings);
      // case RoutePath.knowledgeDetailPage:
      //   return pageRoute(const KnowledgeDetailTabPage(), settings: settings);
      // case RoutePath.searchPage:
      //   return pageRoute(SearchPage(), settings: settings);
      // case RoutePath.collectPage:
      //   return pageRoute(const CollectsPage(), settings: settings);
      case RoutePath.aboutPage:
        return pageRoute(const AboutPage(), settings: settings);
    }
    return pageRoute(Scaffold(
      body: SafeArea(
          child: Center(
        child: Text("路由：${settings.name} 不存在"),
      )),
    ));
  }

  static MaterialPageRoute pageRoute(Widget page,
      {RouteSettings? settings,
      bool? fullscreenDialog,
      bool? maintainState,
      bool? allowSnapshotting}) {
    return MaterialPageRoute(
        builder: (context) {
          return page;
        },
        settings: settings,
        fullscreenDialog: fullscreenDialog ?? false,
        maintainState: maintainState ?? true,
        allowSnapshotting: allowSnapshotting ?? true);
  }
}

// 定义所有路由地址
class RoutePath {
  // 启动页
  static const String splash = "/splash";

  // 首页
  static const String tab = "/";

  // 网页页面（list item 二级）
  static const String webViewPage = "/web_view_page";

  // 登录页面
  static const String loginPage = "/login_page";

  // 注册页面
  static const String registerPage = "/register_page";

  // 体系明细页面
  static const String knowledgeDetailPage = "/knowledge_detail_page";

  // 搜索页面
  static const String searchPage = "/search_page";

  // 我的收藏页面
  static const String collectPage = "/collect_page";

  // 关于我们页面
  static const String aboutPage = "/about_page";
}
