import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/models/RideRequest.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/widgets/lifecycle/locator.dart';

import 'helpers/storage/storage.helper.dart';

class Application {
  static Application _instance;
  bool isDebug;

  static Application getInstance() {
    if (_instance == null) {
      _instance = Application();
    }
    return _instance;
  }

  @protected
  Application();

  Future init() async {
  }


  Future<String> getToken() async {
    return await StorageHelper.get(StorageKeys.token);
  }

  Future<UserDetails> getCustomer() async {
    var userData = await StorageHelper.get(StorageKeys.client);
    if (userData != null) {
      return UserDetails.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<RideRequest> getRideRequest() async {
    var userData = await StorageHelper.get(StorageKeys.rideRequest);
    if (userData != null) {
      return RideRequest.fromJson(jsonDecode(userData));
    }
    return null;
  }

}

