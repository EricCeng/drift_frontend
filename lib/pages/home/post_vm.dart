import 'package:drift_frontend/repository/api.dart';
import 'package:drift_frontend/repository/data/post_list_data.dart';
import 'package:flutter/material.dart';

class PostViewModel with ChangeNotifier {
  List<PostData> personalPostList = [];
  List<PostData> collectionPostList = [];
  List<PostData> likePostList = [];
  List<PostData> postList = [];
  int personalPage = 0;
  int collectionPage = 0;
  int likePage = 0;
  int postPage = 0;

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
      postPage++;
    } else {
      postPage = 0;
    }
    List<PostData>? list =
        await Api.instance.getAllPostList(following, postPage);
    if (list != null && list.isNotEmpty) {
      postList.addAll(list);
      notifyListeners();
    } else {
      if (loadMore && postPage > 0) {
        postPage--;
      }
    }
  }
}
