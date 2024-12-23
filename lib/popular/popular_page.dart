import 'package:flutter/material.dart';

class PopularPage extends StatefulWidget {
  const PopularPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PopularPageState();
  }
}

class _PopularPageState extends State<PopularPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("热门"),
      ),
    );
  }
}
