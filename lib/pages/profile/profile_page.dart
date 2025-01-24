import 'dart:async';
import 'dart:convert';

import 'package:drift_frontend/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:drift_frontend/pages/profile/profile_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DriftPersonalPage extends StatefulWidget {
  const DriftPersonalPage({super.key, this.userId});

  final num? userId;

  @override
  State<StatefulWidget> createState() {
    return _PersonalPageState();
  }
}

class _PersonalPageState extends State<DriftPersonalPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  RefreshController _refreshController = RefreshController();

  // 滑动过程中 AppBar 背景透明度的动态变化
  double _appBarBackgroundOpacity = 0.0;

  // 从背景图中提取的主色
  Color _backgroundImageMainColor = Colors.blue;

  // 控制头像的 Y 轴位置
  double offset = 0;

  // 用来获取简介文本区域的高度
  final GlobalKey _textKey = GlobalKey();

  // 简介文本高度
  double _textHeight = 0;

  // 保存筛选的本地图片路径
  List<String> imagePaths = [];

  // 保存每张图片的宽高比
  List<double?> imageRatios = [];

  ProfileViewModel viewModel = ProfileViewModel();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: 3, vsync: this);
    viewModel.getProfileData(widget.userId);
    _extractMainColor();
    _loadAssets();
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
      const AssetImage('assets/images/default_background.jpg'), // 替换为你的背景图路径
    );
    if (mounted) {
      setState(() {
        _backgroundImageMainColor =
            paletteGenerator.dominantColor?.color ?? Colors.blue;
      });
    }
  }

  // 加载既定的动态图片及计算图片宽高比
  Future<void> _loadAssets() async {
    // 获取 AssetManifest 中的所有资源路径
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // 筛选以 post_image 开头的 jpg 文件
    final filteredPaths = manifestMap.keys
        .where((path) =>
            path.startsWith('assets/images/post_image') &&
            path.endsWith('.jpg'))
        .toList();

    // 初始化宽高比列表
    setState(() {
      imagePaths = filteredPaths;
      // imageRatios = List.filled(filteredPaths.length, null);
    });

    // 计算每张图片的宽高比
    // for (int i = 0; i < filteredPaths.length; i++) {
    //   final ratio = await ImageRatioCache.get(filteredPaths[i]);
    //   setState(() {
    //     imageRatios[i] = ratio;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewModel>(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: SmartRefreshWidget(
          controller: _refreshController,
          header: new ClassicHeader(
            refreshStyle: RefreshStyle.Behind,
          ),
          // enablePullDown: widget.userId == null ? true : false,
          onRefresh: () {
            viewModel.getProfileData(widget.userId);
            _refreshController.refreshCompleted();
          },
          onLoading: () {
            _refreshController.loadComplete();
          },
          child: Stack(
            children: [
              NestedScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    // 个人信息
                    SliverToBoxAdapter(child: _buildProfileInfo()),
                  ];
                },
                body: Column(
                  children: [
                    // 正常滑动的 TabBar
                    if (offset < 300.h + _textHeight - kToolbarHeight)
                      _buildTabBar(),
                    // 使 TabBarView 占满剩余空间
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
              // 当滚动到指定位置后固定的 TabBar
              if (offset >= 300.h + _textHeight - kToolbarHeight)
                Positioned(
                  top: kToolbarHeight,
                  left: 0,
                  right: 0,
                  child: _buildTabBar(),
                ),
              // 动态显示的 logo
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                top: offset < 107 ? 107 - offset : 10.h,
                left: MediaQuery.of(context).size.width / 2 - 18.w,
                child: AnimatedOpacity(
                  opacity: (offset < 107 ? 0 : 1),
                  duration: const Duration(milliseconds: 200),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage:
                    const AssetImage('assets/images/default_avatar.jpg'),
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
        // NotificationListener<ScrollNotification>(
        //   onNotification: (notification) {
        //     if (notification is ScrollStartNotification &&
        //         notification.metrics.pixels == 0.0 &&
        //         notification.metrics.axis == Axis.vertical) {
        //       _refreshController.requestRefresh();
        //     }
        //     return false;
        //   },
        //   child: SmartRefreshWidget(
        //     controller: _refreshController,
        //     header: new ClassicHeader(
        //       refreshStyle: RefreshStyle.Behind,
        //     ),
        //     // enablePullDown: widget.userId == null ? true : false,
        //     onRefresh: () {
        //       viewModel.getProfileData(widget.userId);
        //       _refreshController.refreshCompleted();
        //     },
        //     onLoading: () {
        //       _refreshController.loadComplete();
        //     },
        //     child: Stack(
        //       children: [
        //         NestedScrollView(
        //           controller: _scrollController,
        //           // physics: const BouncingScrollPhysics(
        //           //   parent: AlwaysScrollableScrollPhysics(),
        //           // ),
        //           headerSliverBuilder: (context, innerBoxIsScrolled) {
        //             return [
        //               // 个人信息
        //               SliverToBoxAdapter(child: _buildProfileInfo()),
        //             ];
        //           },
        //           body: Column(
        //             children: [
        //               // 正常滑动的 TabBar
        //               if (offset < 300.h + _textHeight - kToolbarHeight)
        //                 _buildTabBar(),
        //               // 使 TabBarView 占满剩余空间
        //               Expanded(
        //                 child: TabBarView(
        //                   controller: _tabController,
        //                   children: [
        //                     _buildDynamicList(),
        //                     _buildDynamicList(),
        //                     _buildDynamicList(),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         // AppBar
        //         _buildAppBar(),
        //         // 当滚动到指定位置后固定的 TabBar
        //         if (offset >= 300.h + _textHeight - kToolbarHeight)
        //           Positioned(
        //             top: kToolbarHeight,
        //             left: 0,
        //             right: 0,
        //             child: _buildTabBar(),
        //           ),
        //         // 动态显示的 logo
        //         AnimatedPositioned(
        //           duration: const Duration(milliseconds: 200),
        //           curve: Curves.easeIn,
        //           top: offset < 107 ? 107 - offset : 10.h,
        //           left: MediaQuery.of(context).size.width / 2 - 18.w,
        //           child: AnimatedOpacity(
        //             opacity: (offset < 107 ? 0 : 1),
        //             duration: const Duration(milliseconds: 200),
        //             child: CircleAvatar(
        //               radius: 18,
        //               backgroundImage:
        //                   const AssetImage('assets/images/default_avatar.jpg'),
        //               child: Container(
        //                 decoration: BoxDecoration(
        //                   shape: BoxShape.circle,
        //                   border: Border.all(
        //                     color: Colors.white,
        //                     width: 0.5.w,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
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
                                    PhosphorIconsRegular.genderMale,
                                    color: Colors.blue[300],
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
      color: Colors.white,
    );

    // 通过 GlobalKey 获取文本区域的高度
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_textKey.currentContext != null &&
          _textKey.currentContext!.findRenderObject() is RenderBox) {
        final RenderBox renderBox =
            _textKey.currentContext!.findRenderObject() as RenderBox;
        // 确保 RenderBox 已经完成布局
        if (renderBox.hasSize) {
          final height = renderBox.size.height;
          if (mounted) {
            setState(() {
              _textHeight = height;
            });
          }
        }
      }
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
    // TODO 有白线
    return Container(
      color: _backgroundImageMainColor,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Colors.deepPurple[200],
                dividerColor: Colors.transparent,
                labelColor: Colors.black87,
                labelStyle: TextStyle(fontSize: 16.sp),
                unselectedLabelColor: Colors.grey,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: '动态'),
                  Tab(text: '收藏'),
                  Tab(text: '赞过'),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: IconButton(
                  icon: Icon(PhosphorIconsRegular.magnifyingGlass),
                  color: Colors.grey,
                  onPressed: () {
                    // 搜索按钮的点击事件
                  },
                ),
              ),
            ],
          )),
    );
  }

  // 动态内容
  Widget _buildDynamicList() {
    return Container(
      color: Colors.grey[100],
      child: MasonryGridView.builder(
        padding: EdgeInsets.all(5.w),
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 两列
        ),
        mainAxisSpacing: 5.w,
        // 列间距
        crossAxisSpacing: 5.w,
        // 行间距
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // 点击事件
            },
            child: _buildItem(index),
          );
        },
      ),
    );
  }

  Widget _buildItem(int index) {
    // final aspectRatio = imageRatios[index];
    final width = MediaQuery.of(context).size.width / 2 - 5.w;
    // 如果宽高比尚未计算完成，展示加载占位符
    // if (aspectRatio == null) {
    //   return Container(
    //     width: width,
    //     height: width,
    //     alignment: Alignment.center,
    //     child: CircularProgressIndicator(),
    //   );
    // }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.r),
                topRight: Radius.circular(4.r),
              ),
              child: Image.asset(
                imagePaths[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '标题标题',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 15.sp),
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/default_avatar.jpg'),
                      radius: 10.r,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'ttudsii',
                      style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                    ),
                    Spacer(),
                    Icon(
                      PhosphorIconsRegular.heart,
                      size: 18.sp,
                      color: Colors.black45,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      '999',
                      style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
