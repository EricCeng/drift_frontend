import 'package:drift_frontend/pages/home/comment_reply_vm.dart';
import 'package:drift_frontend/repository/data/comment_data.dart';
import 'package:drift_frontend/repository/data/comment_list_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  final num? postAuthorId;
  final CommentItemData commentItem;

  const CommentPage({super.key, this.postAuthorId, required this.commentItem});

  @override
  State<StatefulWidget> createState() {
    return _CommentPageState();
  }
}

class _CommentPageState extends State<CommentPage> {
  bool isFirstClick = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 评论者头像
                CircleAvatar(
                  backgroundImage:
                      const AssetImage('assets/images/default_avatar.jpg'),
                  radius: 18.r,
                ),
                SizedBox(width: 10.w),
                // 评论
                _buildComment(
                    widget.commentItem.first, widget.commentItem.comment),
                SizedBox(width: 5.w),
                // 点赞
                _buildLikeButton(widget.commentItem.comment),
              ],
            ),
            // 回复列表
            _buildReplyList(),
            // 展示更多回复
            if (widget.commentItem.replyCount != null &&
                widget.commentItem.replyCount! > 0)
              _buildMoreReplyButton(widget.commentItem.replyCount),
          ],
        ),
      ),
    );
  }

  Widget _buildComment(bool? first, CommentData? comment) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 评论者名称
                _buildAuthorName(comment?.authorInfo?.author ?? "",
                    comment?.authorInfo?.authorId ?? 0),
                SizedBox(width: 5.w),
                // 展示该评论是否由当前动态作者发布
                if (widget.postAuthorId == comment?.authorInfo?.authorId)
                  _buildAuthorIcon(),
              ],
            ),
            SizedBox(height: 3.h),
            // 评论内容
            _buildCommentContent(comment),
            SizedBox(height: 8.h),
            // 展示是否为首条评论
            if (first == true)
              Container(
                height: 18.h,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: Text(
                    "首评",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentContent(CommentData? comment) {
    return RichText(
      text: TextSpan(
        children: [
          // 评论内容
          TextSpan(
            // 最后加个空格
            text: "${comment?.content} ",
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          // 评论内容后拼接评论发布时间及回复字样
          _buildReleaseTimeAndReplySpan(comment?.releaseTime),
        ],
      ),
    );
  }

  Widget _buildReplyList() {
    return Consumer<CommentReplyViewModel>(
      builder: (context, commentReplyViewModel, child) {
        List<CommentData>? replyList = commentReplyViewModel.replyList;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: replyList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: _buildReplyItem(replyList[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildReplyItem(CommentData replyItem) {
    return Padding(
      padding: EdgeInsets.only(left: 45.w, top: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 回复者头像
          CircleAvatar(
            backgroundImage:
                const AssetImage('assets/images/default_avatar.jpg'),
            radius: 13.r,
          ),
          SizedBox(width: 6.w),
          // 回复
          _buildReply(replyItem),
          SizedBox(width: 5.w),
          // 点赞按钮
          _buildLikeButton(replyItem),
        ],
      ),
    );
  }

  Widget _buildReply(CommentData reply) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 回复者名称
                _buildAuthorName(reply.authorInfo?.author ?? "",
                    reply.authorInfo?.authorId ?? 0),
                SizedBox(width: 5.w),
                // 展示该评论是否由当前动态作者发布
                if (widget.postAuthorId == reply.authorInfo?.authorId)
                  _buildAuthorIcon(),
              ],
            ),
            SizedBox(height: 3.h),
            // 回复内容
            _buildReplyContent(reply),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyContent(CommentData reply) {
    return RichText(
      text: TextSpan(
        children: [
          reply.replyUserId != null
              ? TextSpan(children: [
                  TextSpan(
                    text: "回复 ",
                    style: TextStyle(
                      fontSize: 13.sp,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                      text: reply.replyToUserName,
                      recognizer: TapGestureRecognizer()..onTap = () {},
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.5,
                        color: Colors.grey,
                      )),
                  TextSpan(
                    // 最后加个空格
                    text: ": ${reply.content} ",
                    style: TextStyle(
                      fontSize: 13.sp,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ])
              : TextSpan(
                  // 最后加个空格
                  text: "${reply.content} ",
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
          // 回复内容后拼接回复发布时间及回复字样
          _buildReleaseTimeAndReplySpan(reply.releaseTime),
        ],
      ),
    );
  }

  Widget _buildLikeButton(CommentData? item) {
    bool liked = item?.authorInfo?.liked ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: AnimatedScale(
            scale: liked ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              liked ? PhosphorIconsFill.heart : PhosphorIconsRegular.heart,
              color: liked ? Colors.red : Colors.grey[800],
              size: 18.sp,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        if (item?.likedCount != 0)
          Text(
            "${item?.likedCount}",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[800],
            ),
          ),
      ],
    );
  }

  Widget _buildMoreReplyButton(num? replyCount) {
    return Padding(
      padding: EdgeInsets.only(left: 45.w, top: 12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 25.w,
            child: Divider(
              color: Colors.black,
              height: 1.h,
              thickness: 0.1.h,
            ),
          ),
          SizedBox(
            height: 20.h,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 7.w,
                ),
              ),
              child: Text(
                isFirstClick ? "展开 $replyCount 条回复" : "展开更多回复",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.blueGrey[800],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorName(String authorName, num authorId) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        authorName,
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildAuthorIcon() {
    return Container(
      height: 18.h,
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Text(
          "作者",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }

  WidgetSpan _buildReleaseTimeAndReplySpan(releaseTime) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: releaseTime,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.5,
                color: Colors.grey[600],
              ),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Text(
                  "回复",
                  style: TextStyle(
                    fontSize: 12.sp,
                    height: 1.5,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
