import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  late TabController _tabController;

  // 滑动过程中 AppBar 背景透明度的动态变化
  double _appBarBackgroundOpacity = 0.0;

  // // 个人信息区域的高度
  // final double _profileInfoHeight = 240.0;

  // 从背景图中提取的主色
  Color _backgroundImageMainColor = Colors.blue;

  double offset = 0; // 控制头像的 Y 轴位置

  // 用来获取文本区域的高度
  final GlobalKey _textKey = GlobalKey();

  double _textHeight = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: 3, vsync: this);
    _extractMainColor(); // 提取背景图的主色
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.dispose();
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
      double opacity = (offset / (163.0 - kToolbarHeight)).clamp(0.0, 1.0);
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
    return DefaultTabController(
      length: 3, // TabBar 的标签数量
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // 个人信息区域
                SliverToBoxAdapter(
                  child: _buildProfileInfo(),
                ),
                // Tab Area 区域
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabAreaDelegate(
                    tabBar: _buildTabBar(),
                  ),
                ),
                // Tab 内容
                SliverToBoxAdapter(
                  child: _buildTabContent(),
                ),
              ],
            ),
            // AppBar
            _buildAppBar(),
            // 动态显示的 logo
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeIn,
              top: offset < 107 ? 107 - offset : 10.h,
              left: MediaQuery.of(context).size.width / 2 - 18.w,
              child: AnimatedOpacity(
                opacity: (offset < 107 ? 0 : 1),
                duration: Duration(milliseconds: 200),
                child: CircleAvatar(
                  radius: 18,
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
      ),
    );
  }

  // 构建固定的 AppBar
  Widget _buildAppBar() {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: _backgroundImageMainColor.withOpacity(_appBarBackgroundOpacity),
      ),
      child: AppBar(
        leading: const Icon(
          Icons.menu,
          color: Colors.white70,
          size: 32,
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
                height: 300.h + _textHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/default_background.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.grey.withOpacity(0.2),
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
                top: 65.h,
                left: 15.w,
                right: 15.w,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 45.r,
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
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                "ID: 123456789",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white60,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _buildDynamicText(
                        "Fear or love, don't say the answer.\nActions speak louder than words.",
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          // 性别图标+年龄
                          Container(
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.h),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.male,
                                    color: Colors.lightBlueAccent,
                                    size: 12.r,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    "18岁",
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.h),
                              child: Text(
                                "江苏南京",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.h),
                              child: Text(
                                "程序员",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                '454',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                ),
                              ),
                              Text(
                                '关注',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 16.w),
                          Column(
                            children: [
                              Text(
                                '5',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                ),
                              ),
                              Text(
                                '粉丝',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 16.w),
                          Column(
                            children: [
                              Text(
                                '71',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                ),
                              ),
                              Text(
                                '获赞与收藏',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
      fontSize: 14.sp,
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
      // width: 350.w, // 宽度限制
      child: Text(
        truncatedText,
        style: textStyle,
        maxLines: null, // 不限制行数
        // overflow: TextOverflow.ellipsis, // 超过的部分显示为省略号
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      children: [
        Expanded(
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "动态"),
              Tab(text: "收藏"),
              Tab(text: "点赞"),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // 搜索按钮点击事件
          },
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 200, // 填充剩余高度
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildGridContent("动态"),
          _buildGridContent("收藏"),
          _buildGridContent("点赞"),
        ],
      ),
    );
  }

  Widget _buildGridContent(String tabName) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100 + (index % 3) * 20.0,
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 8),
                Text('$tabName 内容 $index',
                    style: TextStyle(fontSize: 14, color: Colors.black)),
              ],
            ),
          ),
        );
      },
    );
  }
}

// 自定义 SliverPersistentHeaderDelegate
class _TabAreaDelegate extends SliverPersistentHeaderDelegate {
  final Widget tabBar;

  _TabAreaDelegate({required this.tabBar});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: tabBar,
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}