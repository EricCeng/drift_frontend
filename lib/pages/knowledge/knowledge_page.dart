import 'package:drift_frontend/pages/knowledge/detail/knowledge_detail_tab_page.dart';
import 'package:drift_frontend/pages/knowledge/knowledge_vm.dart';
import 'package:drift_frontend/repository/data/knowledge_list_data.dart';
import 'package:drift_frontend/route/route_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _KnowledgePageState();
  }
}

class _KnowledgePageState extends State<KnowledgePage> {
  KnowledgeViewModel viewModel = KnowledgeViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.getKnowledgeList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer<KnowledgeViewModel>(
              builder: (context, viewModel, child) {
            return ListView.builder(
              itemCount: viewModel.list?.length ?? 0,
              itemBuilder: (context, index) {
                return _itemView(viewModel.list?[index]);
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _itemView(KnowledgeListData? item) {
    return GestureDetector(
      onTap: () {
        // 进入明细页面
        RouteUtils.push(
            context,
            KnowledgeDetailTabPage(
              tabList: item?.children,
            ));
      },
      child: Container(
        padding:
            EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(5.r)),
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item?.name ?? "",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    viewModel.generalSubTitle(item?.children),
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Icon(CupertinoIcons.right_chevron)
          ],
        ),
      ),
    );
  }
}
