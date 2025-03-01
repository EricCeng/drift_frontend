import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:drift_frontend/pages/home/comment_count_vm.dart';
import 'package:drift_frontend/pages/home/comment_page.dart';
import 'package:drift_frontend/pages/home/comment_vm.dart';
import 'package:drift_frontend/pages/home/post_detail_vm.dart';
import 'package:drift_frontend/pages/home/post_vm.dart';
import 'package:drift_frontend/repository/data/comment_list_data.dart';
import 'package:drift_frontend/repository/data/post_list_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostDetailPage extends StatefulWidget {
  final PostData post;
  final int index;

  const PostDetailPage({super.key, required this.post, required this.index});

  @override
  State<StatefulWidget> createState() {
    return _PostDetailPageState();
  }
}

class _PostDetailPageState extends State<PostDetailPage> {
  PostDetailViewModel postDetailViewModel = PostDetailViewModel();
  CommentViewModel commentViewModel = CommentViewModel();
  CommentCountViewModel commentCountViewModel = CommentCountViewModel();
  final RefreshController _refreshController = RefreshController();
  num? postId;
  num? postAuthorId;

  @override
  void initState() {
    super.initState();
    postId = widget.post.postId;
    postAuthorId = widget.post.authorInfo?.authorId;
    postDetailViewModel.getPostDetail(postId).then((value) {
      _loadCommentList(false);
    });
    commentCountViewModel.getPostCommentCount(postId);
  }

  void _loadCommentList(bool loadMore) {
    commentViewModel
        .getCommentList(postId, postAuthorId, loadMore)
        .then((value) {
      if (loadMore) {
        _refreshController.loadComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return postDetailViewModel;
        }),
        ChangeNotifierProvider(create: (context) {
          return commentViewModel;
        }),
        ChangeNotifierProvider(create: (context) {
          return commentCountViewModel;
        }),
      ],
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: false,
                enablePullUp: true,
                physics: const _LockedBouncingScrollPhysics(),
                header: const MaterialClassicHeader(
                  // 彻底隐藏下拉头
                  height: 0,
                  distance: 0,
                ),
                footer: const ClassicFooter(
                  height: 60,
                  loadStyle: LoadStyle.ShowWhenLoading,
                  failedText: '',
                  idleText: '',
                  loadingText: '',
                  noDataText: '',
                  canLoadingText: '',
                  canLoadingIcon: null,
                  idleIcon: null,
                ),
                onLoading: () {
                  _loadCommentList(true);
                },
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 动态图
                      _buildPostImage(),
                      // 动态信息：标题、内容、发布/编辑时间
                      _buildPostContent(),
                      // 分割线
                      Container(
                        height: 5.h,
                        margin: EdgeInsets.only(left: 10.w, right: 10.w),
                        decoration: BoxDecoration(
                          border: Border(
                              top:
                                  BorderSide(color: Colors.grey, width: 0.1.w)),
                        ),
                      ),
                      // 评论信息
                      _buildCommentInfo(),
                    ],
                  ),
                ),
              ),
            ),
            // 底部动态评论框、点赞、收藏、查看评论
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 0.0,
      leadingWidth: 45.w,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(CupertinoIcons.left_chevron),
      ),
      title: GestureDetector(
        onTap: () {},
        child: Consumer<PostDetailViewModel>(
          builder: (context, postDetailViewModel, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 动态作者头像
                CircleAvatar(
                  backgroundImage:
                      const AssetImage('assets/images/default_avatar.jpg'),
                  radius: 18.r,
                ),
                SizedBox(width: 10.w),
                // 动态作者名称
                Text(
                  postDetailViewModel.postDetail?.authorInfo?.author ?? "",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPostImage() {
    return Image.asset(
      "assets/images/post_image${widget.index % 20}.jpg",
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
    );
  }

  Widget _buildPostContent() {
    return Consumer<PostDetailViewModel>(
      builder: (context, postDetailViewModel, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                postDetailViewModel.postDetail?.title ?? "",
                style: TextStyle(
                  fontSize: 17.sp,
                  height: 1.5,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ).useSystemChineseFont(),
              ),
              SizedBox(height: 10.h),
              Text(
                postDetailViewModel.postDetail?.content ?? "",
                style: TextStyle(
                  fontSize: 15.sp,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                postDetailViewModel.postDetail?.edited ?? false
                    ? "编辑于 ${postDetailViewModel.postDetail?.releaseTime}"
                    : "${postDetailViewModel.postDetail?.releaseTime}",
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 评论数量
          Consumer<CommentCountViewModel>(
            builder: (context, commentCountViewModel, child) {
              num commentCount = commentCountViewModel.commentCount;
              if (commentCount != 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "共 $commentCount 条评论",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 15.h),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          // 评论框
          _buildCommentField(),
          // 评论列表
          _buildCommentListView(),
        ],
      ),
    );
  }

  Widget _buildCommentField() {
    return Row(
      children: [
        // 登录用户头像
        CircleAvatar(
          backgroundImage: const AssetImage('assets/images/default_avatar.jpg'),
          radius: 18.r,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: TextField(
            controller: TextEditingController(),
            decoration: InputDecoration(
              constraints: BoxConstraints(maxHeight: 40.h),
              hintText: " 说点什么...",
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[100],
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.r),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }

  Widget _buildCommentListView() {
    return Consumer<CommentViewModel>(
      builder: (context, commentViewModel, child) {
        List<CommentItemData>? commentList = commentViewModel.commentList;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: commentList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: CommentPage(
                postAuthorId: postAuthorId,
                commentItem: commentList[index],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomBar() {
    final postViewModel =
        ModalRoute.of(context)!.settings.arguments as PostViewModel;
    bool isLiked =
        postViewModel.postList[widget.index].authorInfo?.liked ?? false;
    num likedCount = postViewModel.postList[widget.index].likedCount ?? 0;
    return Container(
      height: 80.h,
      width: double.infinity,
      padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 8.h, bottom: 30.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.1.w)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 评论框
          TextField(
            controller: TextEditingController(),
            decoration: InputDecoration(
              constraints: BoxConstraints(maxHeight: 40.h, maxWidth: 130.w),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Icon(
                  PhosphorIconsRegular.pencilSimpleLine,
                  color: Colors.grey[600],
                  size: 15.sp,
                ),
              ),
              prefixIconConstraints:
                  BoxConstraints.expand(width: 20.w, height: 20.h),
              hintText: "  说点什么...",
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[600],
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[100],
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.r),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onChanged: (value) {},
          ),
          // 点赞
          GestureDetector(
            onTap: () {
              isLiked = !isLiked;
              setState(() {
                if (isLiked) {
                  likedCount++;
                } else {
                  likedCount--;
                }
                widget.post.authorInfo?.liked = isLiked;
                widget.post.likedCount = likedCount;
              });
            },
            child: AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 200),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    isLiked
                        ? PhosphorIconsFill.heart
                        : PhosphorIconsRegular.heart,
                    color: isLiked ? Colors.red : Colors.black,
                    size: 28.sp,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    likedCount == 0 ? "点赞" : "$likedCount",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 收藏
          Consumer<PostDetailViewModel>(
            builder: (context, postDetailViewModel, child) {
              bool isCollected =
                  postDetailViewModel.postDetail?.authorInfo?.collected ??
                      false;
              num collectedCount =
                  postDetailViewModel.postDetail?.collectedCount ?? 0;
              return GestureDetector(
                onTap: () {},
                child: AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        isCollected
                            ? PhosphorIconsFill.star
                            : PhosphorIconsRegular.star,
                        color: isCollected ? Colors.yellow : Colors.black,
                        size: 28.sp,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        collectedCount == 0 ? "收藏" : "$collectedCount",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // 查看评论
          Consumer<CommentCountViewModel>(
            builder: (context, commentCountViewModel, child) {
              num commentCount = commentCountViewModel.commentCount;
              return GestureDetector(
                onTap: () {},
                child: AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        PhosphorIconsRegular.chatCircleDots,
                        color: Colors.black,
                        size: 28.sp,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        commentCount == 0 ? "评论" : "$commentCount",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 自定义物理引擎：禁止下拉越界，允许上拉回弹
class _LockedBouncingScrollPhysics extends BouncingScrollPhysics {
  const _LockedBouncingScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // 关键逻辑：禁止下拉越界 (value < position.pixels 表示下拉动作)
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      return value - position.pixels; // 强制下拉越界距离归零
    }
    // 允许上拉越界
    return super.applyBoundaryConditions(position, value);
  }
}
