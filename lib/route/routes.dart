// 路由管理类
import 'package:drift_frontend/pages/auth/login_page.dart';
import 'package:drift_frontend/pages/auth/register_page.dart';
import 'package:drift_frontend/pages/knowledge/detail/knowledge_detail_tab_page.dart';
import 'package:drift_frontend/pages/search/search_page.dart';
import 'package:drift_frontend/pages/tab_page.dart';
import 'package:drift_frontend/pages/web_view_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.tab:
        return pageRoute(const TabPage(), settings: settings);
      case RoutePath.webViewPage:
        return pageRoute(const WebViewPage(title: "首页跳转来的1"),
            settings: settings);
      case RoutePath.loginPage:
        return pageRoute(const LoginPage(), settings: settings);
      case RoutePath.registerPage:
        return pageRoute(const RegisterPage(), settings: settings);
      case RoutePath.knowledgeDetailPage:
        return pageRoute(const KnowledgeDetailTabPage(), settings: settings);
      case RoutePath.searchPage:
        return pageRoute(SearchPage(), settings: settings);
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
}
