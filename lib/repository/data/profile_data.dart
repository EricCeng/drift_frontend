class ProfileData {
  ProfileData({
    this.userId,
    this.username,
    this.avatarUrl,
    this.bio,
    this.age,
    this.gender,
    this.region,
    this.occupation,
    this.school,
    this.followingCount,
    this.followerCount,
    this.likedCount,
    this.collectedCount,
  });

  ProfileData.fromJson(dynamic json) {
    userId = json['user_id'];
    username = json['username'];
    avatarUrl = json['avatar_url'];
    bio = json['bio'];
    age = json['age'];
    gender = json['gender'];
    region = json['region'];
    occupation = json['occupation'];
    school = json['school'];
    followingCount = json['following_count'];
    followerCount = json['follower_count'];
    likedCount = json['liked_count'];
    collectedCount = json['collected_count'];
  }

  num? userId;
  String? username;
  String? avatarUrl;
  String? bio;
  num? age;
  String? gender;
  String? region;
  String? occupation;
  String? school;
  num? followingCount;
  num? followerCount;
  num? likedCount;
  num? collectedCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['username'] = username;
    map['avatarUrl'] = avatarUrl;
    map['bio'] = bio;
    map['age'] = age;
    map['gender'] = gender;
    map['region'] = region;
    map['occupation'] = occupation;
    map['school'] = school;
    map['followingCount'] = followingCount;
    map['followerCount'] = followerCount;
    map['likedCount'] = likedCount;
    map['collectedCount'] = collectedCount;
    return map;
  }
}
