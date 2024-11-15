/// id : 6
/// link : ""
/// name : "面试"
/// order : 1
/// visible : 1
// 搜索热词列表
class SearchHotKeysListData {
  List<SearchHotKeysData>? keyList;

  SearchHotKeysListData.fromJson(dynamic json) {
    keyList = [];
    if (json is List) {
      for (var element in json) {
        keyList?.add(SearchHotKeysData.fromJson(element));
      }
    }
  }
}

class SearchHotKeysData {
  SearchHotKeysData({
    this.id,
    this.link,
    this.name,
    this.order,
    this.visible,
  });

  SearchHotKeysData.fromJson(dynamic json) {
    id = json['id'];
    link = json['link'];
    name = json['name'];
    order = json['order'];
    visible = json['visible'];
  }

  num? id;
  String? link;
  String? name;
  num? order;
  num? visible;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['link'] = link;
    map['name'] = name;
    map['order'] = order;
    map['visible'] = visible;
    return map;
  }
}
