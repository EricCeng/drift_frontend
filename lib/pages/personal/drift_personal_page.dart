import 'dart:ui' as ui;

import 'package:drift_frontend/common_ui/common_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final ScrollController _scrollController = ScrollController();

  // 滑动过程中 AppBar 背景透明度的动态变化
  double _appBarBackgroundOpacity = 0.0;

  // // 个人信息区域的高度
  // final double _profileInfoHeight = 240.0;

  // 从背景图中提取的主色
  Color _backgroundImageMainColor = Colors.blue;

  double _avatarOffset = 0; // 控制头像的 Y 轴位置

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // _extractMainColor(); // 提取背景图的主色
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // 根据滚动偏移来动态控制头像的偏移量
    setState(() {
      _avatarOffset = _scrollController.offset;
      if (_avatarOffset < 0) _avatarOffset = 0; // 防止负值
    });
  }

  // 从背景图中提取主色
  Future<void> _extractMainColor() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      AssetImage('assets/images/default_background.jpg'), // 替换为你的背景图路径
    );
    setState(() {
      _backgroundImageMainColor =
          paletteGenerator.dominantColor?.color ?? Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 300.0,
                pinned: true,
                backgroundColor: Colors.deepPurple[200],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.deepPurple[200],
                  ),
                ),
                leading: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ListTile(
                      title: Text('Item $index'),
                    );
                  },
                  childCount: 50,
                ),
              ),
            ],
          ),
          // 动态显示的 logo
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            top: _avatarOffset < 150 ? 150 - _avatarOffset : 10.h,
            // 控制 logo 动画出现的时机
            left: MediaQuery.of(context).size.width / 2 - 18.w,
            // 居中显示 logo
            child: AnimatedOpacity(
              opacity: (_avatarOffset < 150 ? 0 : 1), // 控制 logo 的显示与隐藏
              duration: Duration(milliseconds: 500),
              child: CircleAvatar(
                radius: 18, // logo 的大小
                backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 0.5.w,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建固定的 AppBar
  Widget _buildAppBar() {
    return Container(
      height: kToolbarHeight,
      color: Colors.transparent,
      child: AppBar(
        leading: const Icon(
          Icons.menu,
          color: Colors.white60,
        ),
        backgroundColor: Colors.transparent, // 背景色设置为透明
        elevation: 0,
        title: Opacity(
          opacity: _appBarBackgroundOpacity,
          child: Text(
            "User Name",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // 构建个人信息区域
  Widget _buildProfileInfo() {
    return Column(
      children: [
        // 背景图和个人信息区域
        Container(
          height: 200.h,
          child: Stack(
            children: [
              // 背景图
              // Container(
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage('assets/images/default_background.jpg'),
              //       // 替换为你的背景图路径
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // child: Container(
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment(0.0, 0.67),
              //       end: Alignment.bottomCenter,
              //       colors: [
              //         _backgroundImageMainColor.withOpacity(0.0),
              //         _backgroundImageMainColor.withOpacity(0.2),
              //         _backgroundImageMainColor.withOpacity(0.4),
              //         _backgroundImageMainColor.withOpacity(0.6),
              //         _backgroundImageMainColor.withOpacity(0.8),
              //         _backgroundImageMainColor,
              //       ],
              //       stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
              //     ),
              //   ),
              // ),
              // ),
              // 个人信息内容
              Container(
                // width: double.infinity,
                color: Colors.deepPurple[200],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                          'assets/images/default_avatar.jpg'), // 替换为你的头像路径
                    ),
                    SizedBox(height: 8),
                    Text(
                      "User Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "简介：Flutter 开发者 | 热爱生活",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 统计信息部分
        Container(
          color: Colors.deepPurple[200],
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatistic("关注", "120"),
              SizedBox(width: 16),
              _buildStatistic("粉丝", "1.5k"),
              SizedBox(width: 16),
              _buildStatistic("获赞与收藏", "3.2k"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatistic(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
