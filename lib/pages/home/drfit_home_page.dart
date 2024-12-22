import 'package:flutter/material.dart';

class DriftHomePage extends StatefulWidget {
  const DriftHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<DriftHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("首页"));
  }
}
