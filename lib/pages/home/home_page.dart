import 'package:drift_frontend/common_ui/loading.dart';
import 'package:drift_frontend/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:drift_frontend/pages/home/home_vm.dart';
import 'package:drift_frontend/route/route_utils.dart';
import 'package:drift_frontend/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../repository/data/home_list_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // List<BannerItemData>? bannerList;
  HomeViewModel viewModel = HomeViewModel();
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    // initBannerData();
    // viewModel.initDio();
    Loading.showLoading();
    viewModel.getBanner();
    refreshOrLoadMore(false);
  }

  // void initBannerData() async {
  //   bannerList = await HomeViewModel.getBanner();
  //   // 异步获取数据后 setState 做下刷新
  //   setState(() {});
  // }

  void refreshOrLoadMore(bool loadMore) {
    viewModel.initHomeListData(loadMore).then((value) {
      if (loadMore) {
        refreshController.loadComplete();
      } else {
        refreshController.refreshCompleted();
      }
      Loading.dismissAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: SafeArea(
          child: SmartRefreshWidget(
            controller: refreshController,
            onRefresh: () {
              // 下拉刷新回调
              viewModel.getBanner().then((value) {
                refreshOrLoadMore(false);
              });
            },
            onLoading: () {
              // 上拉加载回调
              refreshOrLoadMore(true);
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // banner
                  _banner(),
                  // 列表
                  _homeListView()
                ],
              ),
            ),
          ), // 下拉刷新/上拉加载
        ),
      ),
    );
  }

  Widget _banner() {
    return Consumer<HomeViewModel>(builder: (context, viewModel, child) {
      print("banner 刷新");
      return SizedBox(
        height: 150.h,
        width: double.infinity,
        // 滑动窗口
        child: Swiper(
          itemCount: viewModel.bannerList?.length ?? 0,
          indicatorLayout: PageIndicatorLayout.NONE,
          autoplay: true,
          pagination: const SwiperPagination(),
          control: const SwiperControl(),
          itemBuilder: (context, index) {
            return Container(
              width: double.infinity,
              // margin: EdgeInsets.all(15),
              height: 150.h,
              color: Colors.white24,
              child: Image.network(
                viewModel.bannerList?[index]?.imagePath ?? "",
                fit: BoxFit.fill,
              ),
            );
          },
        ),
      );
    });
  }

  Widget _homeListView() {
    return Consumer<HomeViewModel>(builder: (context, viewModel, child) {
      print("home list view 刷新");
      return ListView.builder(
        shrinkWrap: true,
        // ListView 内部去计算其所有子组件整体的高度，以让 SingleChildScrollView 知道整体的高度
        physics: const NeverScrollableScrollPhysics(),
        // 禁止 ListView 的滑动事件，由 SingleChildScrollView 接管
        itemBuilder: (context, index) {
          return _listItemView(viewModel.listData?[index], index);
        },
        itemCount: viewModel.listData?.length ?? 0,
      );
    });
  }

  // 设计列表 item
  Widget _listItemView(HomeListItemData? item, int index) {
    String author;
    if (item?.author?.isNotEmpty == true) {
      author = item?.author ?? "";
    } else {
      author = item?.shareUser ?? "";
    }
    // 设置点击事件：GestureDetector & InkWell（有点击水波纹的效果）
    return GestureDetector(
      onTap: () {
        // 隐式路由跳转
        // Navigator.pushNamed(context, RoutePath.webViewPage);
        // RouteUtils.push(context, WebViewPage(title: "首页跳转来的2"));
        // 静态路由传值
        RouteUtils.pushForNamed(context, RoutePath.webViewPage,
            arguments: {"name": "使用路由传值"});
        // 跳转页面
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return WebViewPage(
        //     title: "首页跳转来的",
        //   );
        // }));
      },
      // 上下结构用 column
      child: Container(
          // 装饰边框
          // 外边距
          margin:
              EdgeInsets.only(top: 5.h, bottom: 5.h, left: 10.w, right: 10.w),
          // 内边距
          padding:
              EdgeInsets.only(top: 15.h, bottom: 15.h, left: 10.w, right: 10.w),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 0.5.r),
              borderRadius: BorderRadius.all(Radius.circular(6.r))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左右结构用 row
              Row(
                children: [
                  // 图片：用项目中的资源用 Image.asset，网络资源则用 Image.network
                  // 设置圆形图片
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(15.r),
                  //   child: Image.network(
                  //     "https://img-baofun.zhhainiao.com/pcwallpaper_ugc/static/ca9ee136145baaa56052ddfcc75c3386.jpg?x-oss-process=image%2fresize%2cm_lfit%2cw_1920%2ch_1080",
                  //     width: 30.r,
                  //     height: 30.r,
                  //     fit: BoxFit.fill,
                  //   ),
                  // ),
                  CircleAvatar(
                    backgroundImage: const NetworkImage(
                        // "https://pic2.zhimg.com/v2-1c87fba3bf5c0ced0aedf44c91832941_r.jpg",
                        "https://img-baofun.zhhainiao.com/pcwallpaper_ugc/static/ca9ee136145baaa56052ddfcc75c3386.jpg?x-oss-process=image%2fresize%2cm_lfit%2cw_1920%2ch_1080"),
                    radius: 15.r,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    author,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Text(item?.niceShareDate ?? "",
                        style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                  ),
                  // 置顶判断
                  item?.type?.toInt() == 0
                      ? const Text("置顶",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold))
                      : const SizedBox(),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(item?.title ?? "",
                  style: TextStyle(color: Colors.black, fontSize: 14.sp)),
              SizedBox(
                height: 5.h,
              ),
              Row(
                children: [
                  Text(item?.chapterName ?? "",
                      style: TextStyle(color: Colors.green, fontSize: 12.sp)),
                  const Expanded(child: SizedBox()),
                  // FaIcon(
                  //   FontAwesomeIcons.heart,
                  //   color: Colors.black26,
                  //   size: 20,
                  // )S
                  GestureDetector(
                    onTap: () {
                      bool isCollect;
                      if (item?.collect == true) {
                        isCollect = false;
                      } else {
                        isCollect = true;
                      }
                      viewModel.collect(isCollect, "${item?.id}", index);
                    },
                    child: item?.collect == true
                        ? const Icon(
                            Icons.favorite_rounded,
                            color: Colors.redAccent,
                          )
                        : const Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.black26,
                          ),
                  )
                  // Icon(
                  //   CupertinoIcons.heart,
                  //   color: Colors.black26,
                  // )
                ],
              )
            ],
          )),
    );
  }
}
