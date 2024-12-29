// import 'package:drift_frontend/common_ui/common_style.dart';
// import 'package:drift_frontend/common_ui/loading.dart';
// import 'package:drift_frontend/common_ui/smart_refresh/smart_refresh_widget.dart';
// import 'package:drift_frontend/pages/collects/collects_vm.dart';
// import 'package:drift_frontend/repository/data/collects_list_data.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// import '../../common_ui/web/webview_page.dart';
// import '../../common_ui/web/webview_widget.dart';
// import '../../route/route_utils.dart';

// class CollectsPage extends StatefulWidget {
//   const CollectsPage({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return _CollectsPageState();
//   }
// }

// class _CollectsPageState extends State<CollectsPage> {
//   CollectsViewModel viewModel = CollectsViewModel();
//   RefreshController refreshController = RefreshController();

//   @override
//   void initState() {
//     super.initState();
//     Loading.showLoading();
//     _refreshOrLoadMore(false);
//   }

//   void _refreshOrLoadMore(bool loadMore) async {
//     viewModel.getCollectsList(loadMore).then((value) {
//       if (loadMore) {
//         refreshController.loadComplete();
//       } else {
//         refreshController.refreshCompleted();
//       }
//       Loading.dismissAll();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) {
//         return viewModel;
//       },
//       child: Scaffold(
//         appBar: AppBar(title: const Text("我的收藏")),
//         body: SafeArea(
//           child: Consumer<CollectsViewModel>(
//             builder: (context, viewModel, child) {
//               return SmartRefreshWidget(
//                 controller: refreshController,
//                 onRefresh: () {
//                   _refreshOrLoadMore(false);
//                 },
//                 onLoading: () {
//                   _refreshOrLoadMore(true);
//                 },
//                 child: ListView.builder(
//                   itemCount: viewModel.collectItemList.length,
//                   itemBuilder: (context, index) {
//                     return _listItem(
//                       viewModel.collectItemList[index],
//                       cancelCollect: () {
//                         // 取消收藏
//                         viewModel.cancelCollect(index,
//                             "${viewModel.collectItemList[index].originId}");
//                       },
//                       itemClick: () {
//                         // 详情跳转
//                         RouteUtils.push(
//                           context,
//                           WebViewPage(
//                             loadResource:
//                                 viewModel.collectItemList[index].link ?? "",
//                             webViewType: WebViewType.URL,
//                             showTitle: true,
//                             title: viewModel.collectItemList[index].title,
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _listItem(CollectItemData? item,
//       {GestureTapCallback? cancelCollect, GestureTapCallback? itemClick}) {
//     return GestureDetector(
//       onTap: itemClick,
//       child: Container(
//         margin: EdgeInsets.all(10.r),
//         padding: EdgeInsets.all(15.r),
//         decoration: BoxDecoration(
//             border: Border.all(color: Colors.black38),
//             borderRadius: BorderRadius.circular(10.r)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(children: [
//               Expanded(child: Text("作者: ${item?.author}")),
//               Text("时间: ${item?.niceDate}")
//             ]),
//             SizedBox(height: 6.h),
//             Text("${item?.title}", style: titleTextStyle15),
//             SizedBox(height: 6.h),
//             Row(children: [
//               Expanded(child: Text("分类: ${item?.chapterName}")),
//               GestureDetector(
//                 onTap: cancelCollect,
//                 child: const Icon(
//                   Icons.favorite_rounded,
//                   color: Colors.redAccent,
//                 ),
//               ),
//             ]),
//           ],
//         ),
//       ),
//     );
//   }
// }
