import 'package:drift_frontend/repository/api.dart';
import 'package:drift_frontend/repository/data/post_detail_data.dart';
import 'package:flutter/material.dart';

class PostDetailViewModel with ChangeNotifier {
  PostDetailData? postDetail;

  Future getPostDetail(num? postId) async {
    postDetail = await Api.instance.getPostDetail(postId);
    notifyListeners();
  }
}
