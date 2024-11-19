import 'package:drift_frontend/common_ui/navigation/navigation_bar_widget.dart';
import 'package:drift_frontend/pages/home/home_page.dart';
import 'package:drift_frontend/pages/knowledge/knowledge_page.dart';
import 'package:drift_frontend/pages/message/message_page.dart';
import 'package:drift_frontend/pages/personal/personal_page.dart';
import 'package:drift_frontend/pages/search/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      const HomePage(),
      const KnowledgePage(),
      const SearchPage(),
      const MessagePage(),
      const PersonalPage()
    ];
    labels = ["首页", "体系", "发现", "消息", "我"];
    icons = [
      const Icon(Icons.home_outlined),
      const Icon(CupertinoIcons.book),
      const Icon(CupertinoIcons.compass),
      const Icon(CupertinoIcons.chat_bubble),
      const Icon(CupertinoIcons.person)
    ];
    activeIcons = [
      const Icon(Icons.home_rounded),
      const Icon(CupertinoIcons.book_fill),
      const Icon(CupertinoIcons.compass_fill),
      const Icon(CupertinoIcons.chat_bubble_fill),
      const Icon(CupertinoIcons.person_fill)
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
