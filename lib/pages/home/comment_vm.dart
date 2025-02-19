import 'package:drift_frontend/repository/api.dart';
import 'package:drift_frontend/repository/data/comment_list_data.dart';
import 'package:flutter/material.dart';

class CommentViewModel extends ChangeNotifier {
  List<CommentItemData> commentList = [];

  Future getCommentList(num? postId, num? userId, int page) async {
    List<CommentItemData>? list =
        await Api.instance.getPostCommentList(postId, userId, page);
    if (list != null && list.isNotEmpty) {
      commentList.addAll(list);
    }
    notifyListeners();
  }
}