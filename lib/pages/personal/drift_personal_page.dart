import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class DriftPersonalPage extends StatefulWidget {
  const DriftPersonalPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PersonalPageState();
  }
}

class _PersonalPageState extends State<DriftPersonalPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 设置一个 bar，覆盖在 appBar 的顶部，其下层是背景图
          SliverAppBar(
            expandedHeight: 250.0,
            floating: true,
            pinned: true,
            backgroundColor: Colors.black.withOpacity(0.3),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/default_background2.jpg'), // 背景图
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.multiply),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16.0,
                    left: 16.0,
                    child: IconButton(
                      icon: Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        // TODO: 添加设置按钮的点击事件
                      },
                    ),
                  ),
                  Positioned(
                    top: 16.0,
                    right: 16.0,
                    child: IconButton(
                      icon: Icon(Icons.share, color: Colors.white),
                      onPressed: () {
                        // TODO: 添加分享按钮的点击事件
                      },
                    ),
                  ),
                  Positioned(
                    top: 16.0, // 根据滚动位置更新头像位置
                    left: 16.0, // 个人信息区域左侧的头像位置
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/images/default_avatar.jpg'),
                    ),
                  ),
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: Column(
                      children: [
                        Text('用户名',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text('简介', style: TextStyle(color: Colors.white)),
                        Text('地区: 地区信息', style: TextStyle(color: Colors.white)),
                        Text('性别: 男', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 8.0),
                        Divider(color: Colors.white),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(children: [
                                Text('关注数',
                                    style: TextStyle(color: Colors.white)),
                                Text('100',
                                    style: TextStyle(color: Colors.white))
                              ]),
                              Column(children: [
                                Text('粉丝数',
                                    style: TextStyle(color: Colors.white)),
                                Text('200',
                                    style: TextStyle(color: Colors.white))
                              ]),
                              Column(children: [
                                Text('获赞',
                                    style: TextStyle(color: Colors.white)),
                                Text('300',
                                    style: TextStyle(color: Colors.white))
                              ]),
                              Column(children: [
                                Text('收藏数',
                                    style: TextStyle(color: Colors.white)),
                                Text('400',
                                    style: TextStyle(color: Colors.white))
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: '动态'),
                  Tab(text: '收藏'),
                  Tab(text: '点赞'),
                ],
                indicatorColor: Colors.blue,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // 根据选中的 Tab 显示相应内容
                if (_tabController.index == 0) {
                  return ListTile(title: Text('动态项目 $index'));
                } else if (_tabController.index == 1) {
                  return ListTile(title: Text('收藏项目 $index'));
                } else {
                  return ListTile(title: Text('点赞项目 $index'));
                }
              },
              childCount: 30, // 假设有 30 个项目
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
