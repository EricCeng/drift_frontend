import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift_frontend/repository/data/app_check_update_data.dart';
import 'package:drift_frontend/repository/data/collects_list_data.dart';
import 'package:drift_frontend/repository/data/common_website_data.dart';
import 'package:drift_frontend/repository/data/knowledge_detail_list_data.dart';
import 'package:drift_frontend/repository/data/knowledge_list_data.dart';
import 'package:drift_frontend/repository/data/post_list_data.dart';
import 'package:drift_frontend/repository/data/profile_data.dart';
import 'package:drift_frontend/repository/data/search_hot_keys_data.dart';
import 'package:drift_frontend/repository/data/search_list_data.dart';
import '../http/dio_instance.dart';
import 'data/home_banner_data.dart';
import 'data/home_list_data.dart';

class Api {
  static Api instance = Api._();

  Api._();

  // 检查登录状态
  Future<void> check() async {
    await DioInstance.instance().get(path: "/auth/check");
  }

  // 注册
  Future<dynamic> register(
      {String? phoneNumber, String? password, String? rePassword}) async {
    Map<String, dynamic> requestData = {
      "phone_number": phoneNumber,
      "password": password,
      "re_password": rePassword,
    };
    Response response = await DioInstance.instance().post(
      path: "/auth/register",
      data: jsonEncode(requestData),
    );
    return response.data;
  }

  // 登录
  Future<dynamic> login({String? phoneNumber, String? password}) async {
    Map<String, dynamic> requestData = {
      "phone_number": phoneNumber,
      "password": password,
    };
    Response response = await DioInstance.instance().post(
      path: "/auth/login",
      data: jsonEncode(requestData),
    );
    return response.data;
  }

  Future<ProfileData> getProfile(num? userId) async {
    Map<String, dynamic>? params;
    if (userId != null) {
      params = {"user_id": userId};
    }
    Response response =
        await DioInstance.instance().get(path: "/user/info", param: params);
    ProfileData profileData = ProfileData.fromJson(response.data);
    return profileData;
  }

  Future<List<PostData>?> getPersonalPostList(num? userId, int page) async {
    Map<String, dynamic>? params;
    if (userId == null) {
      params = {"page": page};
    } else {
      params = {"page": page, "user_id": userId};
    }
    Response response =
        await DioInstance.instance().get(path: "/post/personal", param: params);
    PostListData list = PostListData.fromJson(response.data);
    return list.postList;
  }

  Future<List<PostData>?> getCollectionPostList(num? userId, int page) async {
    Map<String, dynamic>? params;
    if (userId == null) {
      params = {"page": page};
    } else {
      params = {"page": page, "user_id": userId};
    }
    Response response = await DioInstance.instance()
        .get(path: "/post/collection", param: params);
    PostListData list = PostListData.fromJson(response.data);
    return list.postList;
  }

  Future<List<PostData>?> getLikePostList(int page) async {
    Response response = await DioInstance.instance()
        .get(path: "/post/like", param: {"page": page});
    PostListData list = PostListData.fromJson(response.data);
    return list.postList;
  }

  Future<List<PostData>?> getAllPostList(bool following, int page) async {
    Map<String, dynamic>? params = {
      "page": page,
      "following": following
    };
    Response response =
        await DioInstance.instance().get(path: "/post/all", param: params);
    PostListData list = PostListData.fromJson(response.data);
    return list.postList;
  }

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

  // 获取体系详情数据
  Future<List<KnowledgeDetailItem>?> knowledgeDetailList(
      String? page, String? cid) async {
    Response response = await DioInstance.instance()
        .get(path: "/article/list/$page/json", param: {"cid": cid});
    var knowledgeDetailListData =
        KnowledgeDetailListData.fromJson(response.data);
    return knowledgeDetailListData.datas;
  }

  // 搜索数据
  Future<List<SearchListItemData>?> searchList(
      String? page, String? keyword) async {
    Response response = await DioInstance.instance().post(
        path: "/article/query/$page/json", queryParameters: {"k": keyword});
    var searchListData = SearchListData.fromJson(response.data);
    return searchListData.datas;
  }

  // 我的收藏列表
  Future<List<CollectItemData>?> collectList(String? page) async {
    Response response =
        await DioInstance.instance().get(path: "/lg/collect/list/$page/json");
    var collectListData = CollectsListData.fromJson(response.data);
    return collectListData.datas;
  }

  // 取消收藏
  Future<bool?> unCollectFromMyCollect(String? id) async {
    Response response = await DioInstance.instance()
        .post(path: "/lg/uncollect_originId/$id/json");
    return boolCallback(response.data);
  }

  // 检查 app 新版本
  Future<AppCheckUpdateData?> checkAppUpdate() async {
    DioInstance.instance().changeBaseUrl("https://www.pgyer.com");
    Response response = await DioInstance.instance()
        .post(path: "/apiv2/app/check", queryParameters: {
      "_api_key": "6144518b048b93253e3ec351165116a0",
      "appKey": "8cf47ad6c31c49681150ad6cfc8dae83"
    });
    DioInstance.instance().changeBaseUrl("https://www.wanandroid.com");
    return AppCheckUpdateData.fromJson(response.data);
  }

  bool? boolCallback(dynamic data) {
    if (data != null && data is bool) {
      return data;
    }
    return false;
  }
}
