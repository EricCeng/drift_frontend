import 'dart:developer';

import 'package:drift_frontend/repository/api.dart';
import 'package:drift_frontend/repository/data/post_list_data.dart';
import 'package:flutter/material.dart';

class PostViewModel with ChangeNotifier {
  List<PostData> personalPostList = [];
  List<PostData> collectionPostList = [];
  List<PostData> likePostList = [];
  List<PostData> allPostList = [];
  List<PostData> followingPostList = [];
  int personalPage = 0;
  int collectionPage = 0;
  int likePage = 0;
  int allPage = 0;
  int followingPage = 0;

  Future getPersonalPostList(num? userId) async {
    List<PostData>? list =
        await Api.instance.getPersonalPostList(userId, personalPage);
    if (list != null && list.isNotEmpty) {
      personalPostList.addAll(list);
    }
    notifyListeners();
  }

  Future getCollectionPostList(num? userId) async {
    List<PostData>? list =
        await Api.instance.getCollectionPostList(userId, collectionPage);
    if (list != null && list.isNotEmpty) {
      collectionPostList.addAll(list);
    }
    notifyListeners();
  }

  Future getLikePostList() async {
    List<PostData>? list = await Api.instance.getLikePostList(likePage);
    if (list != null && list.isNotEmpty) {
      likePostList.addAll(list);
    }
    notifyListeners();
  }

  Future getAllPostList(bool following, bool loadMore) async {
    if (loadMore) {
      following ? followingPage++ : allPage++;
    } else {
      following ? followingPage = 0 : allPage = 0;
    }
    List<PostData>? list = await Api.instance
        .getAllPostList(following, following ? followingPage : allPage);
    if (list != null && list.isNotEmpty) {
      if (following) {
        followingPostList.addAll(list);
      } else {
        allPostList.addAll(list);
      }
      notifyListeners();
    } else {
      if (loadMore && (following ? followingPage : allPage) > 0) {
        following ? followingPage-- : allPage--;
      }
    }
  }
}
