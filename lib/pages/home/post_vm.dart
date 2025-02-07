import 'dart:developer';

import 'package:drift_frontend/repository/api.dart';
import 'package:drift_frontend/repository/data/post_list_data.dart';
import 'package:flutter/material.dart';

class PostViewModel with ChangeNotifier {
  List<PostData> personalPostList = [];
  List<PostData> allPostList = [];
  List<PostData> followingPostList = [];
  int page = 0;
  bool _isFetchingAll = false;

  Future getPersonalPostList(num? userId) async {
    List<PostData>? list = await Api.instance.getPersonalPostList(userId, page);
    if (list != null && list.isNotEmpty) {
      personalPostList.addAll(list);
    }
    notifyListeners();
  }

  Future getAllPostList() async {
    log("getAllPostList called, _isFetchingAll: $_isFetchingAll");
    if (_isFetchingAll) {
      log("getAllPostList skipped: Already fetching");
      return;
    }
    _isFetchingAll = true;
    log("getAllPostList started");

    try {
      List<PostData>? list = await Api.instance.getAllPostList(false, page);
      if (list != null && list.isNotEmpty) {
        allPostList.addAll(list);
        notifyListeners();
      }
    } finally {
      _isFetchingAll = false;
    }
  }

  Future getFollowingPostList() async {
    List<PostData>? list = await Api.instance.getAllPostList(true, page);
    if (list != null && list.isNotEmpty) {
      followingPostList.addAll(list);
    }
    notifyListeners();
  }
}
