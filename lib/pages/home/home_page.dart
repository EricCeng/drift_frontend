import 'package:drift_frontend/route/route_utils.dart';
import 'package:drift_frontend/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            // banner
            _banner(),
            // 列表
            ListView.builder(
              shrinkWrap: true,
              // ListView 内部去计算其所有子组件整体的高度，以让 SingleChildScrollView 知道整体的高度
              physics: NeverScrollableScrollPhysics(),
              // 禁止 ListView 的滑动事件，由 SingleChildScrollView 接管
              itemBuilder: (context, index) {
                return _listItemView();
              },
              itemCount: 20,
            )
          ],
        ),
      )),
    );
  }

  Widget _banner() {
    return SizedBox(
      height: 150.h,
      width: double.infinity,
      // 滑动窗口
      child: Swiper(
        itemCount: 3,
        indicatorLayout: PageIndicatorLayout.NONE,
        autoplay: true,
        pagination: const SwiperPagination(),
        control: const SwiperControl(),
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            // margin: EdgeInsets.all(15),
            height: 150.h,
            color: Colors.lightBlue,
          );
        },
      ),
    );
  }

  // 设计列表 item
  Widget _listItemView() {
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
                    backgroundImage: NetworkImage(
                        // "https://pic2.zhimg.com/v2-1c87fba3bf5c0ced0aedf44c91832941_r.jpg",
                        "https://img-baofun.zhhainiao.com/pcwallpaper_ugc/static/ca9ee136145baaa56052ddfcc75c3386.jpg?x-oss-process=image%2fresize%2cm_lfit%2cw_1920%2ch_1080"),
                    radius: 15.r,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    "作者",
                    style: TextStyle(color: Colors.black),
                  ),
                  Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Text("2024-11-08 16:23:43",
                        style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                  ),
                  Text("置顶",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                ],
              ),
              Text("标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标",
                  style: TextStyle(color: Colors.black, fontSize: 14.sp)),
              Row(
                children: [
                  Text("分类",
                      style: TextStyle(color: Colors.green, fontSize: 12.sp)),
                  Expanded(child: SizedBox()),
                  FaIcon(
                    FontAwesomeIcons.heart,
                    color: Colors.black26,
                    size: 20,
                  )
                ],
              )
            ],
          )),
    );
  }
}
