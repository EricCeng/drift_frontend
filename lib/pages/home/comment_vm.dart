import 'package:drift_frontend/repository/api.dart';
import 'package:drift_frontend/repository/data/comment_list_data.dart';
import 'package:flutter/material.dart';

class CommentViewModel extends ChangeNotifier {
  List<CommentItemData> commentList = [];
  int page = 0;

  Future getCommentList(num? postId, num? userId, bool loadMore) async {
    if (loadMore) {
      page++;
    } else {
      page = 0;
    }
    List<CommentItemData>? list =
        await Api.instance.getPostCommentList(postId, userId, page);
    if (list != null && list.isNotEmpty) {
      commentList.addAll(list);
      notifyListeners();
    } else {
      if (loadMore && page > 0) {
        page--;
      }
    }
  }
}
