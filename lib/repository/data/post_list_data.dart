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
    this.postId,
    this.title,
    this.firstImageUrl,
    this.authorId,
    this.author,
    this.authorAvatarUrl,
    this.liked,
    this.likedCount,
  });

  PostData.fromJson(dynamic json) {
    postId = json['post_id'];
    title = json['title'];
    firstImageUrl = json['first_image_url'];
    authorId = json['author_id'];
    author = json['author'];
    authorAvatarUrl = json['author_avatar_url'];
    liked = json['postliked_id'];
    likedCount = json['liked_count'];
  }

  num? postId;
  String? title;
  String? firstImageUrl;
  num? authorId;
  String? author;
  String? authorAvatarUrl;
  bool? liked;
  num? likedCount;
}
