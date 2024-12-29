// import 'package:drift_frontend/repository/api.dart';
// import 'package:flutter/cupertino.dart';

// import '../../repository/data/common_website_data.dart';
// import '../../repository/data/search_hot_keys_data.dart';

// class HotKeyViewModel with ChangeNotifier {
//   List<CommonWebsiteData>? websiteList;
//   List<SearchHotKeysData>? keyList;

//   Future initData() async {
//     getWebsiteList().then((value) {
//       getSearchHotKeys().then((value) {
//         notifyListeners();
//       });
//     });
//   }

//   // 获取常用网站数据
//   Future getWebsiteList() async {
//     websiteList = await Api.instance.getWebsiteList();
//   }

//   // 获取搜索热词数据
//   Future getSearchHotKeys() async {
//     keyList = await Api.instance.getSearchHotKeys();
//   }
// }
