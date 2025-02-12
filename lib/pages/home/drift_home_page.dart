import 'dart:convert';
import 'dart:developer';

import 'package:drift_frontend/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:drift_frontend/pages/home/post_vm.dart';
import 'package:drift_frontend/repository/data/post_list_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class DriftHomePage extends StatefulWidget {
  const DriftHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<DriftHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<bool> _hasLoaded = [false, false];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TabPage(index: 0, hasLoaded: _hasLoaded),
                  TabPage(index: 1, hasLoaded: _hasLoaded),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
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
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: IconButton(
              icon: const Icon(PhosphorIconsRegular.list),
              color: Colors.black87,
              onPressed: () {
                // 搜索按钮的点击事件
              },
            ),
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.deepPurple[200],
            dividerColor: Colors.transparent,
            labelColor: Colors.black87,
            labelStyle: TextStyle(fontSize: 16.sp),
            unselectedLabelColor: Colors.grey,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: '关注'),
              Tab(text: '发现'),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
              icon: const Icon(PhosphorIconsRegular.magnifyingGlass),
              color: Colors.black87,
              onPressed: () {
                // 搜索按钮的点击事件
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TabPage extends StatefulWidget {
  final int index;
  final List<bool> hasLoaded;

  const TabPage({super.key, required this.index, required this.hasLoaded});

  @override
  State<StatefulWidget> createState() {
    return _TabPageState();
  }
}

class _TabPageState extends State<TabPage> with AutomaticKeepAliveClientMixin {
  PostViewModel postViewModel = PostViewModel();
  late RefreshController _refreshController;
  bool following = false;

  // 保存筛选的本地图片路径
  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadAssets();
    _refreshController = RefreshController();
    if (!widget.hasLoaded[widget.index]) {
      _refreshOrLoadMore(false, widget.index);
      // 标记该 tab 已加载
      widget.hasLoaded[widget.index] = true;
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _refreshOrLoadMore(bool loadMore, int tabIndex) {
    following = tabIndex == 0;
    postViewModel.getAllPostList(following, loadMore).then((value) {
      log('loading');
      if (loadMore) {
        _refreshController.loadComplete();
      } else {
        _refreshController.refreshCompleted();
      }
    });
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
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 确保状态不会丢失
    return ChangeNotifierProvider<PostViewModel>(
      create: (context) {
        return postViewModel;
      },
      child: SmartRefreshWidget(
        controller: _refreshController,
        onRefresh: () {
          log('onRefresh');
          _refreshOrLoadMore(false, widget.index);
        },
        onLoading: () {
          _refreshOrLoadMore(true, widget.index);
        },
        child: Consumer<PostViewModel>(
          builder: (context, viewModel, child) {
            List<PostData> list =
                following ? viewModel.followingPostList : viewModel.allPostList;
            return _buildTabView(list);
          },
        ),
      ),
    );
  }

  Widget _buildTabView(List<PostData> list) {
    return Container(
      color: Colors.grey[100],
      // child: MasonryGridView.builder(
      //   padding: EdgeInsets.all(5.w),
      //   // 两列
      //   gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2,
      //   ),
      //   // 列间距
      //   mainAxisSpacing: 5.w,
      //   // 行间距
      //   crossAxisSpacing: 5.w,
      //   itemCount: list.length,
      //   itemBuilder: (context, index) {
      //     return GestureDetector(
      //       onTap: () {
      //         // 点击事件
      //       },
      //       child: _buildItem(index, list[index]),
      //     );
      //   },
      // ),
      child: WaterfallFlow.builder(
        padding: const EdgeInsets.all(5.0),
        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0.w,
          mainAxisSpacing: 5.0.w,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // 点击事件
            },
            child: _buildItem(index, list[index]),
          );
        },
      ),
    );
  }

  Widget _buildItem(int index, PostData? post) {
    final width = MediaQuery.of(context).size.width / 2 - 5.w;
    bool isLiked = post?.liked ?? false;
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
                imagePaths[index % imagePaths.length],
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
                  post?.title ?? "",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          const AssetImage('assets/images/default_avatar.jpg'),
                      radius: following ? 14.r : 10.r,
                    ),
                    SizedBox(width: 6.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${post?.author}",
                          style:
                              TextStyle(fontSize: 10.sp, color: Colors.grey[700]),
                        ),
                        if (following)
                          Text(
                            "${post?.releaseTime}",
                            style: TextStyle(
                                fontSize: 10.sp, color: Colors.black38),
                          ),
                      ],
                    ),
                    const Spacer(),
                    // 点赞按钮
                    GestureDetector(
                      onTap: () {},
                      child: AnimatedScale(
                        scale: isLiked ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isLiked ? PhosphorIconsFill.heart : PhosphorIconsRegular.heart,
                          color: isLiked ? Colors.red : Colors.black45,
                          size: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    // 点赞数
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "5434",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    // Icon(
                    //   (post?.liked ?? false)
                    //       ? PhosphorIconsFill.heart
                    //       : CupertinoIcons.heart,
                    //   size: 16.sp,
                    //   color:
                    //       (post?.liked ?? false) ? Colors.red : Colors.black45,
                    // ),
                    // SizedBox(width: 3.w),
                    // Text(
                    //   "5434",
                    //   style:
                    //   TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
                    // ),
                    // if (post?.likedCount != 0)
                    //   Text(
                    //     "${post?.likedCount}",
                    //     style:
                    //         TextStyle(fontSize: 10.sp, color: Colors.black54),
                    //   ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true; // 保持页面状态
}
