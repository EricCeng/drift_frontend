import 'package:drift_frontend/repository/data/author_info_data.dart';

class PostListData {
  List<PostData>? postList;

  PostListData.fromJson(dynamic json) {
    postList = [];
    if (json is List) {
      for (var element in json) {
        postList?.add(PostData.fromJson(element));
      }
    }
  }
}

class PostData {
  PostData({
    this.authorInfo,
    this.postId,
    this.title,
    this.firstImageUrl,
    this.releaseTime,
    this.likedCount,
  });

  PostData.fromJson(dynamic json) {
    authorInfo = AuthorInfoData.fromJson(json['author_info']);
    postId = json['post_id'];
    title = json['title'];
    firstImageUrl = json['first_image_url'];
    releaseTime = json['release_time'];
    likedCount = json['liked_count'];
  }

  AuthorInfoData? authorInfo;
  num? postId;
  String? title;
  String? firstImageUrl;
  String? releaseTime;
  num? likedCount;
}
