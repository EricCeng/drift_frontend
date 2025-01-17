import 'package:drift_frontend/pages/auth/auth_vm.dart';
import 'package:drift_frontend/pages/tab_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../route/route_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  AuthViewModel viewModel = AuthViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.check().then((value) {
      RouteUtils.push(context, TabPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: Image.asset('assets/images/splash_screen.jpg'),
        ),
      ),
    );
  }
}
