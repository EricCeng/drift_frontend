import 'package:drift_frontend/common_ui/common_style.dart';
import 'package:drift_frontend/common_ui/loading.dart';
import 'package:drift_frontend/common_ui/smart_refresh/smart_refresh_widget.dart';
import 'package:drift_frontend/pages/knowledge/detail/knowledge_detail_vm.dart';
import 'package:drift_frontend/repository/data/knowledge_detail_list_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class KnowledgeTabChildPage extends StatefulWidget {
  const KnowledgeTabChildPage({super.key, this.cid});

  final String? cid;

  @override
  State<StatefulWidget> createState() {
    return _KnowledgeTabChildPageState();
  }
}

class _KnowledgeTabChildPageState extends State<KnowledgeTabChildPage> {
  KnowledgeDetailViewModel viewModel = KnowledgeDetailViewModel();
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    Loading.showLoading();
    _refreshOrLoadMore(false);
  }

  void _refreshOrLoadMore(bool loadMore) async {
    viewModel.getDetailList(widget.cid, loadMore).then((value) {
      if (loadMore) {
        refreshController.loadComplete();
      } else {
        refreshController.refreshCompleted();
      }
      Loading.dismissAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: Consumer<KnowledgeDetailViewModel>(
          builder: (context, viewModel, child) {
            return SmartRefreshWidget(
              controller: refreshController,
              onRefresh: () {
                _refreshOrLoadMore(false);
              },
              onLoading: () {
                _refreshOrLoadMore(true);
              },
              child: ListView.builder(
                itemCount: viewModel.detailList.length,
                itemBuilder: (context, index) {
                  return _item(
                      viewModel.detailList.isNotEmpty == true
                          ? viewModel.detailList[index]
                          : KnowledgeDetailItem(),
                      onTap: () {});
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _item(KnowledgeDetailItem? item, {GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 0.5.r)),
        child: Column(
          children: [
            Row(
              children: [
                normalText(item?.superChapterName),
                const Expanded(child: SizedBox()),
                Text("${item?.niceShareDate}"),
              ],
            ),
            Text("${item?.title}", style: titleTextStyle15),
            Row(
              children: [
                normalText(item?.chapterName),
                const Expanded(child: SizedBox()),
                Text("${item?.shareUser}"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
