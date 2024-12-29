// import 'package:drift_frontend/common_ui/loading.dart';
// import 'package:drift_frontend/common_ui/smart_refresh/smart_refresh_widget.dart';
// import 'package:drift_frontend/pages/search/search_vm.dart';
// import 'package:drift_frontend/route/route_utils.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// import '../../common_ui/web/webview_page.dart';
// import '../../common_ui/web/webview_widget.dart';

// class SearchPage extends StatefulWidget {
//   SearchPage({super.key, this.keyword});

//   String? keyword;

//   @override
//   State<StatefulWidget> createState() {
//     return _SearchPageState();
//   }
// }

// class _SearchPageState extends State<SearchPage> {
//   late TextEditingController inputController;
//   SearchViewModel viewModel = SearchViewModel();
//   RefreshController refreshController = RefreshController();

//   @override
//   void initState() {
//     super.initState();
//     inputController = TextEditingController(text: widget.keyword ?? "");
//     Loading.showLoading();
//     _refreshOrLoadMore(false);
//   }

//   void _refreshOrLoadMore(bool loadMore) async {
//     viewModel.search(widget.keyword, loadMore).then((value) {
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
//         body: SafeArea(
//             child: Column(
//           children: [
//             // 搜索框
//             _searchBar(
//               onBack: () {
//                 RouteUtils.pop(context);
//               },
//               onCancel: () {
//                 inputController.text = "";
//                 viewModel.clear();
//                 FocusScope.of(context).unfocus();
//               },
//               onSubmitted: (value) {
//                 Loading.showLoading();
//                 setState(() {
//                   widget.keyword = value;
//                 });
//                 _refreshOrLoadMore(false);
//                 // 回车搜索后隐藏软键盘
//                 // 方式一 原生
//                 // SystemChannels.textInput.invokeMethod("TextInput.hide");
//                 // 方式二
//                 FocusScope.of(context).unfocus();
//               },
//             ),
//             // ListView
//             Expanded(
//               child: Consumer<SearchViewModel>(
//                 builder: (context, viewModel, child) {
//                   return SmartRefreshWidget(
//                     controller: refreshController,
//                     onRefresh: () {
//                       _refreshOrLoadMore(false);
//                     },
//                     onLoading: () {
//                       _refreshOrLoadMore(true);
//                     },
//                     child: ListView.builder(
//                       itemCount: viewModel.searchList.length,
//                       itemBuilder: (context, index) {
//                         return _listItem(
//                           viewModel.searchList.isNotEmpty == true
//                               ? (viewModel.searchList[index].title)
//                               : "",
//                           () {
//                             RouteUtils.push(
//                               context,
//                               WebViewPage(
//                                 loadResource:
//                                     viewModel.searchList[index].link ?? "",
//                                 webViewType: WebViewType.URL,
//                                 showTitle: true,
//                                 title: viewModel.searchList[index].title,
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             )
//           ],
//         )),
//       ),
//     );
//   }

//   Widget _listItem(String? title, GestureTapCallback? onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//             border:
//                 Border(bottom: BorderSide(width: 1.r, color: Colors.black12))),
//         padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
//         child: Html(
//           data: title ?? "",
//           style: {'html': Style(fontSize: FontSize(15.sp))},
//         ),
//       ),
//     );
//   }

//   Widget _searchBar(
//       {GestureTapCallback? onBack,
//       GestureTapCallback? onCancel,
//       ValueChanged<String>? onSubmitted}) {
//     return Container(
//       height: 50.h,
//       width: double.infinity,
//       color: Colors.white24,
//       child: Row(
//         children: [
//           SizedBox(width: 10.w),
//           GestureDetector(
//             onTap: onBack,
//             child:
//                 const Icon(CupertinoIcons.left_chevron, color: Colors.black54),
//           ),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.all(8.r),
//               child: TextField(
//                 keyboardType: TextInputType.text,
//                 textInputAction: TextInputAction.search,
//                 onSubmitted: onSubmitted,
//                 controller: inputController,
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(
//                     CupertinoIcons.search,
//                     color: Colors.black38,
//                     size: 20.sp,
//                   ),
//                   fillColor: Colors.grey[220],
//                   filled: true,
//                   contentPadding: EdgeInsets.only(left: 10.w),
//                   enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.white24),
//                       borderRadius: BorderRadius.circular(15.r)),
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.white24),
//                       borderRadius: BorderRadius.circular(15.r)),
//                 ),
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: onCancel,
//             child: Text("取消",
//                 style: TextStyle(color: Colors.black45, fontSize: 16.sp)),
//           ),
//           SizedBox(width: 15.w),
//         ],
//       ),
//     );
//   }
// }
