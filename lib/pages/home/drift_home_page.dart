import 'dart:convert';
import 'dart:developer';

import 'package:drift_frontend/pages/home/post_vm.dart';
import 'package:drift_frontend/repository/data/post_list_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

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

  // 保存筛选的本地图片路径
  List<String> imagePaths = [];

  PostViewModel postViewModel = PostViewModel();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: 2, vsync: this);
    _loadAssets();
    // 避免在 initState 里同步执行网络请求
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTabData(_tabController.index);
    });
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        log("indexIsChanging");
        _fetchTabData(_tabController.index);
      }
    });
  }

  void _fetchTabData(int tabIndex) async {
    log("fetch tab data: $tabIndex");
    switch (tabIndex) {
      case 0:
        // 获取关注动态
        await postViewModel.getFollowingPostList();
        setState(() {});
        break;
      case 1:
        // 获取发现动态
        await postViewModel.getAllPostList();
        setState(() {});
        break;
      default:
        break;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: postViewModel,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTabView(postViewModel.followingPostList),
                    _buildTabView(postViewModel.allPostList),
                  ],
                ),
              ),
            ],
          ),
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

  Widget _buildTabView(List<PostData> list) {
    return Container(
      color: Colors.grey[100],
      child: MasonryGridView.builder(
        padding: EdgeInsets.all(5.w),
        // 两列
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        // 列间距
        mainAxisSpacing: 5.w,
        // 行间距
        crossAxisSpacing: 5.w,
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
                  style: TextStyle(fontSize: 15.sp),
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          const AssetImage('assets/images/default_avatar.jpg'),
                      radius: 10.r,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      post?.author ?? "",
                      style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                    ),
                    const Spacer(),
                    Icon(
                      (post?.liked ?? false)
                          ? PhosphorIconsFill.heart
                          : PhosphorIconsRegular.heart,
                      size: 18.sp,
                      color:
                          (post?.liked ?? false) ? Colors.red : Colors.black45,
                    ),
                    SizedBox(width: 3.w),
                    if (post?.likedCount != 0)
                      Text(
                        "${post?.likedCount}",
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.black54),
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
