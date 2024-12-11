import 'package:drift_frontend/repository/api.dart';
import 'package:drift_frontend/repository/data/collects_list_data.dart';
import 'package:flutter/material.dart';

class CollectsViewModel extends ChangeNotifier {
  List<CollectItemData> collectItemList = [];
  int _page = 0;

  Future getCollectsList(bool loadMore) async {
    if (loadMore) {
      _page++;
    } else {
      _page = 0;
      collectItemList.clear();
    }
    var list = await Api.instance.collectList("$_page");
    if (list?.isNotEmpty == true) {
      collectItemList.addAll(list ?? []);
      notifyListeners();
    } else {
      if (loadMore && _page > 0) {
        _page--;
      }
    }
  }

  Future cancelCollect(int index, String? id) async {
    bool? success = await Api.instance.unCollectFromMyCollect(id ?? "");
    if (success == true) {
      collectItemList.remove(collectItemList[index]);
      notifyListeners();
    }
  }
}
