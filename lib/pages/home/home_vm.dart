import 'package:drift_frontend/repository/api.dart';
import 'package:flutter/cupertino.dart';

import '../../repository/data/home_banner_data.dart';
import '../../repository/data/home_list_data.dart';

class HomeViewModel with ChangeNotifier {
  List<HomeBannerData?>? bannerList;
  List<HomeListItemData>? listData = [];

  // Dio dio = Dio();
  //
  // void initDio() {
  //   dio.options = BaseOptions(
  //       method: "GET",
  //       baseUrl: "https://www.wanandroid.com",
  //       connectTimeout: Duration(seconds: 30),
  //       receiveTimeout: Duration(seconds: 30),
  //       sendTimeout: Duration(seconds: 30));
  // }

  // 获取首页 banner 数据
  Future getBanner() async {
    bannerList = await Api.instance.getBanner() ?? [];
    notifyListeners();
  }

  Future initHomeListData() async {
    await getHomeTopList();
    await getHomeList();
  }

  // 获取首页文章列表
  Future getHomeList() async {
    listData?.addAll(await Api.instance.getHomeList() ?? []);
    notifyListeners();
  }

  // 获取首页置顶列表
  Future getHomeTopList() async {
    listData?.clear();
    listData?.addAll(await Api.instance.getHomeTopList() ?? []);
    notifyListeners();
  }
}
