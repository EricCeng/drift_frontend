import 'package:drift_frontend/repository/data/author_info_data.dart';

class CommentData {
  CommentData({
    this.authorInfo,
    this.commentId,
    this.content,
    this.releaseTime,
    this.likedCount,
    this.replyUserId,
    this.replyToUserName,
  });

  CommentData.fromJson(dynamic json) {
    authorInfo = AuthorInfoData.fromJson(json['author_info']);
    commentId = json['comment_id'];
    content = json['content'];
    releaseTime = json['release_time'];
    likedCount = json['liked_count'];
    replyUserId = json['reply_user_id'];
    replyToUserName = json['reply_to_user_name'];
  }

  AuthorInfoData? authorInfo;
  num? commentId;
  String? content;
  String? releaseTime;
  num? likedCount;
  num? replyUserId;
  String? replyToUserName;
}
