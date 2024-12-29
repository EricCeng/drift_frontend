// import 'package:drift_frontend/repository/api.dart';
// import 'package:flutter/cupertino.dart';

// import '../../repository/data/home_banner_data.dart';
// import '../../repository/data/home_list_data.dart';

// class HomeViewModel with ChangeNotifier {
//   int page = 0;
//   List<HomeBannerData?>? bannerList;
//   List<HomeListItemData>? listData = [];

//   // Dio dio = Dio();
//   //
//   // void initDio() {
//   //   dio.options = BaseOptions(
//   //       method: "GET",
//   //       baseUrl: "https://www.wanandroid.com",
//   //       connectTimeout: Duration(seconds: 30),
//   //       receiveTimeout: Duration(seconds: 30),
//   //       sendTimeout: Duration(seconds: 30));
//   // }

//   // 获取首页 banner 数据
//   Future getBanner() async {
//     bannerList = await Api.instance.getBanner() ?? [];
//     notifyListeners();
//   }

//   Future initHomeListData(bool loadMore) async {
//     if (loadMore) {
//       page++;
//     } else {
//       page = 0;
//     }
//     await getHomeTopList(loadMore);
//     await getHomeList(loadMore);
//   }

//   // 获取首页置顶列表
//   Future getHomeTopList(bool loadMore) async {
//     if (!loadMore) {
//       listData?.clear();
//       listData?.addAll(await Api.instance.getHomeTopList() ?? []);
//     }
//   }

//   // 获取首页文章列表
//   Future getHomeList(bool loadMore) async {
//     List<HomeListItemData>? list = await Api.instance.getHomeList("$page");
//     if (list != null && list.isNotEmpty) {
//       listData?.addAll(list);
//     } else {
//       if (loadMore && page > 0) {
//         page--;
//       }
//     }
//     notifyListeners();
//   }

//   Future collect(bool isCollect, String? id, int index) async {
//     bool? success = isCollect
//         ? await Api.instance.collect(id)
//         : await Api.instance.unCollect(id);
//     if (success == true) {
//       listData?[index].collect = isCollect;
//       notifyListeners();
//     }
//   }
// }
