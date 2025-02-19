import 'package:drift_frontend/repository/data/comment_data.dart';

class CommentListData {
  List<CommentItemData>? commentList;

  CommentListData.fromJson(dynamic json) {
    commentList = [];
    if (json is List) {
      for (var element in json) {
        commentList?.add(CommentItemData.fromJson(element));
      }
    }
  }
}

class CommentItemData {
  CommentItemData({
    this.comment,
    this.earliestReply,
    this.replyCount,
    this.first,
  });

  CommentItemData.fromJson(dynamic json) {
    comment =
        json['comment'] != null ? CommentData.fromJson(json['comment']) : null;
    earliestReply = json['earliest_reply'] != null
        ? CommentData.fromJson(json['earliest_reply'])
        : null;
    replyCount = json['reply_count'];
    first = json['first'];
  }

  CommentData? comment;
  CommentData? earliestReply;
  num? replyCount;
  bool? first;
}
