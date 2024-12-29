// import 'package:drift_frontend/pages/hot_key/hot_key_vm.dart';
// import 'package:drift_frontend/pages/search/search_page.dart';
// import 'package:drift_frontend/repository/data/common_website_data.dart';
// import 'package:drift_frontend/route/route_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// import '../../common_ui/web/webview_page.dart';
// import '../../common_ui/web/webview_widget.dart';
// import '../../repository/data/search_hot_keys_data.dart';

// class HotKeyPage extends StatefulWidget {
//   const HotKeyPage({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return _HotKeyPageState();
//   }
// }

// // 常用网站 item 回调
// typedef WebsiteClick = Function(String name, String link);

// class _HotKeyPageState extends State<HotKeyPage> {
//   HotKeyViewModel viewModel = HotKeyViewModel();

//   @override
//   void initState() {
//     super.initState();
//     viewModel.initData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) {
//         return viewModel;
//       },
//       child: Scaffold(
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Expanded(
//               child: Column(
//                 children: [
//                   // 搜索热词-标题
//                   Container(
//                     height: 45.h,
//                     decoration: BoxDecoration(
//                         border: Border(
//                             top: BorderSide(width: 1.r, color: Colors.grey),
//                             bottom:
//                                 BorderSide(width: 1.r, color: Colors.grey))),
//                     padding: EdgeInsets.only(left: 20.w, right: 20.w),
//                     child: Row(
//                       children: [
//                         Text(
//                           "搜索热词",
//                           style:
//                               TextStyle(fontSize: 14.sp, color: Colors.black),
//                         ),
//                         const Expanded(child: SizedBox()),
//                         GestureDetector(
//                           onTap: () {
//                             RouteUtils.push(context, SearchPage());
//                           },
//                           child: Icon(
//                             Icons.search_rounded,
//                             size: 30.sp,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   // 搜索热词-网格列表
//                   Consumer<HotKeyViewModel>(
//                       builder: (context, viewModel, child) {
//                     return _gridView(false, keyList: viewModel.keyList,
//                         itemTap: (value) {
//                       // 进入搜索页面
//                       RouteUtils.push(context, SearchPage(keyword: value));
//                     });
//                   }),
//                   // 常用网站-标题
//                   Container(
//                     height: 45.h,
//                     alignment: Alignment.centerLeft,
//                     decoration: BoxDecoration(
//                         border: Border(
//                             top: BorderSide(width: 1.r, color: Colors.grey),
//                             bottom:
//                                 BorderSide(width: 1.r, color: Colors.grey))),
//                     margin: EdgeInsets.only(top: 20.h),
//                     padding: EdgeInsets.only(left: 20.w, right: 20.w),
//                     child: Text(
//                       "常用网站",
//                       style: TextStyle(fontSize: 14.sp, color: Colors.black),
//                     ),
//                   ),
//                   // 常用网站-网格列表
//                   Consumer<HotKeyViewModel>(
//                     builder: (context, viewModel, child) {
//                       return _gridView(
//                         true,
//                         websiteList: viewModel.websiteList,
//                         websiteClick: (name, link) {
//                           RouteUtils.push(
//                             context,
//                             WebViewPage(
//                               loadResource: link,
//                               webViewType: WebViewType.URL,
//                               showTitle: true,
//                               title: name,
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _gridView(
//     bool? isWebsite, {
//     List<CommonWebsiteData>? websiteList,
//     List<SearchHotKeysData>? keyList,
//     ValueChanged<String>? itemTap,
//     WebsiteClick? websiteClick,
//   }) {
//     return Container(
//         // 上边距
//         margin: EdgeInsets.only(top: 20.h),
//         // 左右缩进
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: GridView.builder(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           // 定义网格布局，各网格间距宽高比等
//           gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//             mainAxisSpacing: 8.r, // 主轴间隔
//             maxCrossAxisExtent: 120.w, // 最大横轴范围
//             childAspectRatio: 3, // 宽高比
//             crossAxisSpacing: 10.r, // 横轴间隔
//           ),
//           itemBuilder: (context, index) {
//             if (isWebsite == true) {
//               return _item(
//                   name: websiteList?[index].name,
//                   link: websiteList?[index].link,
//                   websiteClick: websiteClick);
//             } else {
//               return _item(name: keyList?[index].name, itemTap: itemTap);
//             }
//           },
//           itemCount: isWebsite == true
//               ? websiteList?.length ?? 0
//               : keyList?.length ?? 0,
//         ));
//   }

//   Widget _item({
//     String? name,
//     ValueChanged<String>? itemTap,
//     String? link,
//     WebsiteClick? websiteClick,
//   }) {
//     return GestureDetector(
//         onTap: () {
//           if (link != null) {
//             websiteClick?.call(name ?? "", link);
//           } else {
//             itemTap?.call(name ?? "");
//           }
//         },
//         child: Container(
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey, width: 1.r),
//               borderRadius: BorderRadius.all(Radius.circular(10.r))),
//           child: Text(name ?? ""),
//         ));
//   }
// }
