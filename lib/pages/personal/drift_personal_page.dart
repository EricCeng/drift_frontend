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
    return Scaffold(
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(child: _buildProfileInfo()), // 个人信息
                // SliverPersistentHeader(
                //   pinned: true,
                //   floating: false,
                //   delegate: _TabBarDelegate(
                //     tabController: _tabController,
                //     scrollOffset: offset,
                //     textHeight: _textHeight,
                //   ),
                // ),
              ];
            },
            body: Column(
              children: [
                // 正常滑动的 TabBar
                if (offset < 300.h + _textHeight - kToolbarHeight)
                  _buildTabBar(),
                // 当滚动到指定位置后固定的 TabBar
                if (offset >= 300.h + _textHeight - kToolbarHeight)
                  _buildFixedTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDynamicList(),
                      _buildDynamicList(),
                      _buildDynamicList(),
                    ],
                  ),
                ),
              ],
            ),
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

  // TabBar 区域
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorColor: Colors.purple,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: '动态${offset}'),
                Tab(text: '收藏${300.h + _textHeight - kToolbarHeight}'),
                Tab(text: '点赞${_textHeight}'),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 搜索按钮的点击事件
            },
          ),
        ],
      ),
    );
  }

  // 固定的 TabBar
  Widget _buildFixedTabBar() {
    return Container(
      padding: EdgeInsets.only(top: 56.h),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorColor: Colors.purple,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: '动态11${offset}'),
                Tab(text: '收藏11${300.h + _textHeight - kToolbarHeight}'),
                Tab(text: '点赞'),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 搜索按钮的点击事件
            },
          ),
        ],
      ),
    );
  }

  // 动态内容
  Widget _buildDynamicList() {
    return GridView.builder(
      padding: EdgeInsets.all(8.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 0.8,
      ),
      itemCount: 20, // 示例项数量
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[300],
                  child: Image.asset(
                    'assets/images/default_avatar.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/default_avatar.jpg'),
                ),
                title: Text('用户名称'),
                trailing: IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    // 点赞按钮点击事件
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final double scrollOffset;
  final double textHeight;

  _TabBarDelegate({
    required this.tabController,
    required this.scrollOffset,
    required this.textHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 确保 TabBar 的固定位置
    double topOffset = scrollOffset < (300.h + textHeight - kToolbarHeight)
        ? scrollOffset
        : (kToolbarHeight); // 固定位置在 AppBar 下方

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: topOffset),  // 控制 TabBar 在合适位置
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: tabController,
              isScrollable: false,
              indicatorColor: Colors.purple,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: '动态${topOffset}'),
                Tab(text: '收藏'),
                Tab(text: '点赞'),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 搜索按钮的点击事件
            },
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 40.0.h; // 设置最大扩展高度

  @override
  double get minExtent => 40.0.h; // 设置最小扩展高度

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}