import 'package:drift_frontend/repository/api.dart';
import 'package:drift_frontend/repository/data/comment_data.dart';
import 'package:flutter/material.dart';

class CommentReplyViewModel extends ChangeNotifier {
  List<CommentData> replyList = [];

  Future getReplyList(num? commentId, num? earliestReplyId, int page) async {
    List<CommentData>? list =
        await Api.instance.getReplyList(commentId, earliestReplyId, page);
    if (list != null && list.isNotEmpty) {
      replyList.addAll(list);
    }
    notifyListeners();
  }
}