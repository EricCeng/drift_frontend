// import 'package:drift_frontend/repository/api.dart';
// import 'package:drift_frontend/repository/data/search_list_data.dart';
// import 'package:flutter/cupertino.dart';

// class SearchViewModel with ChangeNotifier {
//   List<SearchListItemData> searchList = [];
//   int _page = 0;

//   Future search(String? keyword, bool loadMore) async {
//     if (loadMore) {
//       _page++;
//     } else {
//       _page = 0;
//       searchList.clear();
//     }
//     var list = await Api.instance.searchList("$_page", keyword);
//     if (list?.isNotEmpty == true) {
//       searchList.addAll(list ?? []);
//       notifyListeners();
//     } else {
//       if (loadMore && _page > 0) {
//         _page--;
//       }
//     }
//   }

//   void clear() {
//     searchList.clear();
//     notifyListeners();
//   }
// }
