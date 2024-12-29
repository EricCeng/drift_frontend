// import 'package:drift_frontend/repository/data/knowledge_list_data.dart';
// import 'package:flutter/material.dart';

// import '../../repository/api.dart';

// class KnowledgeViewModel with ChangeNotifier {
//   List<KnowledgeListData?>? list;

//   Future getKnowledgeList() async {
//     list = await Api.instance.knowledgeList();
//     notifyListeners();
//   }

//   String generalSubTitle(List<KnowledgeChildren?>? children) {
//     if (children == null || children.isEmpty == true) {
//       return "";
//     }
//     StringBuffer subTitle = StringBuffer("");
//     for (var element in children) {
//       subTitle.write("${element?.name} ");
//     }
//     return subTitle.toString();
//   }
// }
