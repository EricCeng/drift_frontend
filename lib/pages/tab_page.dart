import 'package:drift_frontend/common_ui/navigation/navigation_bar_widget.dart';
import 'package:drift_frontend/pages/home/drift_home_page.dart';
import 'package:drift_frontend/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TabPageState();
  }
}

class _TabPageState extends State<TabPage> {
  // 页面数组
  late List<Widget> pages;

  // 底部标题
  late List<String> labels;

  // 导航栏的 icon 数组：切换前
  late List<Widget> icons;

  // 导航栏的 icon 数组：切换后
  late List<Widget> activeIcons;

  void initTabData() {
    pages = [
      const DriftHomePage(),
      const DriftHomePage(),
      const DriftHomePage(),
      const DriftHomePage(),
      const DriftPersonalPage()
    ];
    labels = ["首页", "热门", "", "消息", "我"];
    icons = [
      const Icon(PhosphorIconsRegular.house, size: 30),
      const Icon(PhosphorIconsRegular.fire, size: 30),
      Icon(
        PhosphorIconsFill.plusCircle,
        size: 45,
        color: Colors.deepPurple[200],
      ),
      const Icon(PhosphorIconsFill.envelopeSimple, size: 30),
      const Icon(PhosphorIconsRegular.ghost, size: 30)
    ];
    activeIcons = [
      Icon(
        PhosphorIconsFill.house,
        size: 32,
        color: Colors.deepPurple[200],
      ),
      Icon(
        PhosphorIconsFill.fire,
        size: 32,
        color: Colors.deepPurple[200],
      ),
      Icon(
        PhosphorIconsFill.plusCircle,
        size: 45,
        color: Colors.deepPurple[200],
      ),
      Icon(
        PhosphorIconsFill.envelopeSimpleOpen,
        size: 32,
        color: Colors.deepPurple[200],
      ),
      Icon(
        PhosphorIconsFill.ghost,
        size: 32,
        color: Colors.deepPurple[200],
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    initTabData();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBarWidget(
      pages: pages,
      labels: labels,
      icons: icons,
      activeIcons: activeIcons,
      currentIndex: 0,
      onTabChange: (index) {},
    );
  }
}
