import 'dart:convert';

import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:drift_frontend/pages/home/post_detail_page.dart';
import 'package:drift_frontend/pages/home/post_vm.dart';
import 'package:drift_frontend/repository/data/post_list_data.dart';
import 'package:drift_frontend/route/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  late List<RefreshController> _refreshControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: 2, vsync: this);
    _refreshControllers =
        List.generate(2, (index) => RefreshController(initialRefresh: false));
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
                  TabPage(
                    index: 0,
                    hasLoaded: _hasLoaded,
                    refreshController: _refreshControllers[0],
                  ),
                  TabPage(
                    index: 1,
                    hasLoaded: _hasLoaded,
                    refreshController: _refreshControllers[1],
                  ),
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
            onTap: (index) {
              if (_tabController.index == index &&
                  !_tabController.indexIsChanging) {
                _refreshControllers[index].requestRefresh();
              }
            },
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
  final RefreshController refreshController;

  const TabPage(
      {super.key,
      required this.index,
      required this.hasLoaded,
      required this.refreshController});

  @override
  State<StatefulWidget> createState() {
    return _TabPageState();
  }
}

class _TabPageState extends State<TabPage> with AutomaticKeepAliveClientMixin {
  PostViewModel postViewModel = PostViewModel();
  final ScrollController _scrollController = ScrollController();
  bool following = false;

  @override
  void initState() {
    super.initState();
    if (!widget.hasLoaded[widget.index]) {
      _refreshOrLoadMore(false, widget.index);
      // 标记该 tab 已加载
      widget.hasLoaded[widget.index] = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refreshOrLoadMore(bool loadMore, int tabIndex) {
    following = tabIndex == 0;
    postViewModel.getAllPostList(following, loadMore).then((value) {
      if (loadMore) {
        widget.refreshController.loadComplete();
      } else {
        widget.refreshController.refreshCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 确保状态不会丢失
    return ChangeNotifierProvider<PostViewModel>(
      create: (context) {
        return postViewModel;
      },
      child: Consumer<PostViewModel>(
        builder: (context, viewModel, child) {
          List<PostData> list =
              following ? viewModel.followingPostList : viewModel.allPostList;
          return Container(
            color: Colors.grey[100],
            child: SmartRefresher(
              controller: widget.refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: const ClassicHeader(
                height: 60,
                releaseText: '',
                refreshingText: '',
                completeText: '',
                failedText: '',
                idleText: '',
                idleIcon: null,
                failedIcon: null,
                completeIcon: null,
                releaseIcon: null,
              ),
              footer: const ClassicFooter(
                height: 60,
                loadStyle: LoadStyle.ShowWhenLoading,
                failedText: '',
                idleText: '',
                loadingText: '',
                noDataText: '',
                canLoadingText: '',
                canLoadingIcon: null,
                idleIcon: null,
              ),
              scrollController: _scrollController,
              onRefresh: () {
                _refreshOrLoadMore(false, widget.index);
              },
              onLoading: () {
                _refreshOrLoadMore(true, widget.index);
              },
              child: _buildTabView(list),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabView(List<PostData> list) {
    return MasonryGridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(5.w),
      // 两列
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      // 列间距
      mainAxisSpacing: 4.w,
      // 行间距
      crossAxisSpacing: 4.w,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // 点击跳转至动态详情页面
            RouteUtils.push(
              context,
              PostDetailPage(
                postId: list[index].postId,
                index: index,
              ),
            );
          },
          child: _buildItem(index, list[index]),
        );
      },
    );
  }

  Widget _buildItem(int index, PostData? post) {
    final width = MediaQuery.of(context).size.width / 2 - 5.w;
    bool isLiked = post?.authorInfo?.liked ?? false;
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
                "assets/images/post_image${index % 20}.jpg",
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
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          const AssetImage('assets/images/default_avatar.jpg'),
                      radius: following ? 13.r : 10.r,
                    ),
                    SizedBox(width: 6.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${post?.authorInfo?.author}",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                        if (following)
                          Text(
                            "${post?.releaseTime}",
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: Colors.black38,
                            ),
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              isLiked
                                  ? PhosphorIconsFill.heart
                                  : PhosphorIconsRegular.heart,
                              color: isLiked ? Colors.red : Colors.black45,
                              size: 16.sp,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              post?.likedCount == 0
                                  ? "赞"
                                  : "${post?.likedCount}",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  @override
  bool get wantKeepAlive => true; // 保持页面状态
}
