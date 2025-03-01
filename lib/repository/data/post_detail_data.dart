import 'package:drift_frontend/repository/data/author_info_data.dart';

class PostDetailData {
  PostDetailData({
    this.authorInfo,
    this.postId,
    this.title,
    this.content,
    this.imageUrlList,
    this.releaseTime,
    this.edited,
    this.likedCount,
    this.collectedCount,
    this.commentCount,
  });

  PostDetailData.fromJson(dynamic json) {
    authorInfo = AuthorInfoData.fromJson(json['author_info']);
    postId = json['post_id'];
    title = json['title'];
    content = json['content'];
    if (json['image_url_list'] != null) {
      imageUrlList = [];
      json['image_url_list'].forEach((v) {
        imageUrlList?.add(v);
      });
    }
    releaseTime = json['release_time'];
    edited = json['edited'];
    likedCount = json['liked_count'];
    collectedCount = json['collected_count'];
    commentCount = json['comment_count'];
  }

  AuthorInfoData? authorInfo;
  num? postId;
  String? title;
  String? content;
  List<String>? imageUrlList;
  String? releaseTime;
  bool? edited;
  num? likedCount;
  num? collectedCount;
  num? commentCount;
}
