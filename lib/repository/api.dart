import 'package:dio/dio.dart';

import '../http/dio_instance.dart';
import 'data/home_banner_data.dart';
import 'data/home_list_data.dart';

class Api {
  static Api instance = Api._();

  Api._();

  // 获取首页 banner 数据
  Future<List<HomeBannerData?>?> getBanner() async {
    Response response = await DioInstance.instance().get(path: "/banner/json");
    HomeBannerListData bannerListData =
        HomeBannerListData.fromJson(response.data);
    return bannerListData.bannerList;
  }

  // 获取首页文章列表
  Future<List<HomeListItemData>?> getHomeList(String page) async {
    Response response =
        await DioInstance.instance().get(path: "/article/list/$page/json");
    HomeListData homeListData = HomeListData.fromJson(response.data);
    return homeListData.datas;
  }

  // 获取首页置顶数据
  Future<List<HomeListItemData>?> getHomeTopList() async {
    Response response =
        await DioInstance.instance().get(path: "/article/top/json");
    HomeTopListData homeTopListData = HomeTopListData.fromJson(response.data);
    return homeTopListData.topList;
  }
}
