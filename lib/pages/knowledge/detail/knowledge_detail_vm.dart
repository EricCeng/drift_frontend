// import 'package:drift_frontend/repository/api.dart';
// import 'package:flutter/material.dart';

// import '../../../repository/data/knowledge_detail_list_data.dart';
// import '../../../repository/data/knowledge_list_data.dart';

// class KnowledgeDetailViewModel with ChangeNotifier {
//   List<Tab> tabs = [];
//   List<KnowledgeDetailItem> detailList = [];
//   int _page = 0;

//   void initTabs(List<KnowledgeChildren>? tabList) {
//     tabList?.forEach((element) {
//       String? tab = element.name;
//       if (tab != null && tab.isNotEmpty) {
//         tabs.add(Tab(text: tab));
//       }
//     });
//   }

//   Future getDetailList(String? cid, bool loadMore) async {
//     if (loadMore) {
//       _page++;
//     } else {
//       _page = 0;
//       detailList.clear();
//     }
//     var list = await Api.instance.knowledgeDetailList("$_page", cid);
//     if (list?.isNotEmpty == true) {
//       detailList.addAll(list ?? []);
//       notifyListeners();
//     } else {
//       if (loadMore && _page > 0) {
//         _page--;
//       }
//     }
//   }
// }
