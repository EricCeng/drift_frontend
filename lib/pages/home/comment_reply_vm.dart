import 'package:drift_frontend/repository/api.dart';
import 'package:drift_frontend/repository/data/comment_data.dart';
import 'package:flutter/material.dart';

class CommentReplyViewModel extends ChangeNotifier {
  List<CommentData> replyList = [];
  int page = -1;

  Future getReplyList(num? commentId, num? earliestReplyId) async {
    page++;
    List<CommentData>? list =
        await Api.instance.getReplyList(commentId, earliestReplyId, page);
    if (list != null && list.isNotEmpty) {
      replyList.addAll(list);
      notifyListeners();
    } else {
      if (page > 0) {
        page--;
      }
    }
  }

  List<CommentData> setEarliestReply(CommentData? earliestReply) {
    if (earliestReply != null && replyList.isEmpty) {
      replyList.add(earliestReply);
    }
    return replyList;
  }
}
