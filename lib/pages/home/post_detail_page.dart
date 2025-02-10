import 'package:flutter/material.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PostDetailPageState();
  }
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("详情"),
      ),
      body: const Center(
        child: Text("详情"),
      ),
    );
  }
}