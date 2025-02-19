import 'package:drift_frontend/repository/data/comment_data.dart';

class ReplyListData {
  List<CommentData>? replyList;

  ReplyListData.fromJson(dynamic json) {
    replyList = [];
    if (json is List) {
      for (var element in json) {
        replyList?.add(CommentData.fromJson(element));
      }
    }
  }
}
