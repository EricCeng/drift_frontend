import 'package:drift_frontend/repository/api.dart';
import 'package:drift_frontend/repository/data/search_list_data.dart';
import 'package:flutter/cupertino.dart';

class SearchViewModel with ChangeNotifier {
  List<SearchListItemData>? searchList;

  Future search(String? keyword) async {
    searchList = await Api.instance.searchList(keyword);
    notifyListeners();
  }

  void clear() {
    searchList?.clear();
    notifyListeners();
  }
}
