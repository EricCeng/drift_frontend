import 'package:drift_frontend/repository/api.dart';
import 'package:flutter/material.dart';

class CommentCountViewModel extends ChangeNotifier {
  num commentCount = 0;

  Future getPostCommentCount(num? postId) async {
    commentCount = await Api.instance.getPostCommentCount(postId);
    notifyListeners();
  }
}
