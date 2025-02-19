class AuthorInfoData {
  AuthorInfoData({
    this.authorId,
    this.author,
    this.authorAvatarUrl,
    this.liked,
    this.collected,
  });

  AuthorInfoData.fromJson(dynamic json) {
    authorId = json['author_id'];
    author = json['author'];
    authorAvatarUrl = json['author_avatar_url'];
    liked = json['liked'];
    collected = json['collected'];
  }

  num? authorId;
  String? author;
  String? authorAvatarUrl;
  bool? liked;
  bool? collected;
}
