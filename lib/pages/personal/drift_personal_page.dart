import 'dart:ui' as ui;

import 'package:drift_frontend/common_ui/common_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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

  double offset = 0; // 控制头像的 Y 轴位置

  // 用来获取文本区域的高度
  GlobalKey _textKey = GlobalKey();

  double _textHeight = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _extractMainColor(); // 提取背景图的主色
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
      offset = _scrollController.offset;
      // 防止负值
      if (offset < 0) {
        offset = 0;
      }
      double opacity = (offset / (90.0 - kToolbarHeight)).clamp(0.0, 1.0);
      if (opacity != _appBarBackgroundOpacity) {
        _appBarBackgroundOpacity = opacity;
      }
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
              SliverToBoxAdapter(
                child: _buildProfileInfo(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(
                    leading: CircleAvatar(
                      child: Text('$index'),
                    ),
                    title: Text('Item $index'),
                  ),
                  childCount: 20,
                ),
              ),
            ],
          ),
          _buildAppBar(),
          // 动态显示的 logo
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
            top: offset < 74 ? 74 - offset : 10.h,
            // 控制 logo 动画出现的时机
            left: MediaQuery.of(context).size.width / 2 - 18.w,
            // 居中显示 logo
            child: AnimatedOpacity(
              opacity: (offset < 74 ? 0 : 1), // 控制 logo 的显示与隐藏
              duration: Duration(milliseconds: 200),
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
      height: 50.h,
      decoration: BoxDecoration(
        color: _backgroundImageMainColor.withOpacity(_appBarBackgroundOpacity),
      ),
      child: AppBar(
        leading: const Icon(
          Icons.menu,
          color: Colors.white60,
        ),
        backgroundColor: Colors.transparent, // 背景色设置为透明
        elevation: 0,
      ),
    );
  }

  // 构建个人信息区域
  Widget _buildProfileInfo() {
    return Column(
      children: [
        // 背景图和个人信息区域
        Container(
          width: double.infinity,
          child: Stack(
            children: [
              // 背景图
              Container(
                height: 160.h + _textHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/default_background.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.0, 0.67),
                      end: Alignment.bottomCenter,
                      colors: [
                        _backgroundImageMainColor.withOpacity(0.0),
                        _backgroundImageMainColor.withOpacity(0.2),
                        _backgroundImageMainColor.withOpacity(0.4),
                        _backgroundImageMainColor.withOpacity(0.6),
                        _backgroundImageMainColor.withOpacity(0.8),
                        _backgroundImageMainColor,
                      ],
                      stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                    ),
                  ),
                ),
              ),
              // 个人信息内容
              Positioned(
                top: 50.h,
                left: 20.w,
                child: Container(
                  width: 200.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 35.r,
                            backgroundImage:
                                AssetImage('assets/images/default_avatar.jpg'),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.5.w,
                                  )),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ttudsii", // 用户名
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                "ID: 123456789",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10.h),
                      _buildDynamicText(
                        "Fear or love, dont't say the answer.\nActions speak louder than words.",
                      ),
                    ],
                  ),
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

  // 限制最大字符数为 100，超过则显示 ...
  Widget _buildDynamicText(String text) {
    // 限制文本的最大字符数为 100
    String truncatedText = text.length > 100 ? text.substring(0, 100) : text;

    // 设置文本样式，宽度为 200px，自动换行
    TextStyle textStyle = TextStyle(
      fontSize: 11.sp,
      // fontWeight: FontWeight.w500,
      color: Colors.white,
    );

    // 通过 GlobalKey 获取文本区域的高度
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _textKey.currentContext!.findRenderObject() as RenderBox;
      final height = renderBox.size.height;
      setState(() {
        _textHeight = height;
      });
    });

    return Container(
      key: _textKey,
      width: 200.w, // 宽度限制
      child: Text(
        truncatedText,
        style: textStyle,
        maxLines: null, // 不限制行数
        // overflow: TextOverflow.ellipsis, // 超过的部分显示为省略号
      ),
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
