import 'package:drift_frontend/repository/data/profile_data.dart';
import 'package:flutter/cupertino.dart';

import '../../repository/api.dart';

class ProfileViewModel with ChangeNotifier {
  ProfileData? profileData;

  Future getProfileData(num? userId) async {
    profileData = await Api.instance.getProfileData(userId);
    notifyListeners();
  }
}