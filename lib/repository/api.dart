import 'package:dio/dio.dart';
import 'package:drift_frontend/repository/data/common_website_data.dart';
import 'package:drift_frontend/repository/data/knowledge_list_data.dart';
import 'package:drift_frontend/repository/data/search_hot_keys_data.dart';
import 'package:drift_frontend/repository/data/user_info_data.dart';

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

  // 获取常用网站数据
  Future<List<CommonWebsiteData>?> getWebsiteList() async {
    Response response = await DioInstance.instance().get(path: "/friend/json");
    CommonWebsiteListData websiteListData =
        CommonWebsiteListData.fromJson(response.data);
    return websiteListData.websiteList;
  }

  // 获取搜索热词数据
  Future<List<SearchHotKeysData>?> getSearchHotKeys() async {
    Response response = await DioInstance.instance().get(path: "/hotkey/json");
    SearchHotKeysListData hotKeysListData =
        SearchHotKeysListData.fromJson(response.data);
    return hotKeysListData.keyList;
  }

  // 注册
  Future<dynamic> register(
      {String? username, String? password, String? rePassword}) async {
    Response response = await DioInstance.instance().post(
        path: "/user/register",
        queryParameters: {
          "username": username,
          "password": password,
          "repassword": rePassword
        });
    return response.data;
  }

  // 登录
  Future<UserInfoData> login({String? username, String? password}) async {
    Response response = await DioInstance.instance()
        .post(path: "/user/login", queryParameters: {
      "username": username,
      "password": password,
    });
    return UserInfoData.fromJson(response.data);
  }

  // 登出
  Future<bool?> logout() async {
    Response response =
        await DioInstance.instance().get(path: "/user/logout/json");
    return boolCallback(response.data);
  }

  // 收藏
  Future<bool?> collect(String? id) async {
    Response response =
        await DioInstance.instance().post(path: "/lg/collect/$id/json");
    return boolCallback(response.data);
  }

  // 取消收藏
  Future<bool?> unCollect(String? id) async {
    Response response = await DioInstance.instance()
        .post(path: "/lg/uncollect_originId/$id/json");
    return boolCallback(response.data);
  }

  // 获取体系数据列表
  Future<List<KnowledgeListData?>?> knowledgeList() async {
    Response response = await DioInstance.instance().get(path: "/tree/json");
    KnowledgeData knowledgeData = KnowledgeData.fromJson(response.data);
    return knowledgeData.list;
  }

  bool? boolCallback(dynamic data) {
    if (data != null && data is bool) {
      return data;
    }
    return false;
  }
}
