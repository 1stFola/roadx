import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class PermissionHandlerBloc extends ChangeNotifier {
  Location location = Location();

  bool isLocationPerGiven = false;
  bool isLocationSerGiven = false;

  PermissionHandlerBloc() {

    location.changeSettings(accuracy: LocationAccuracy.high);
    location.hasPermission().then((isGiven) {
      if (isGiven == PermissionStatus.granted) {
        isLocationPerGiven = true;
        location.serviceEnabled().then((isEnabled) {
          if (isEnabled) {
            isLocationSerGiven = true;
          } else {
            isLocationSerGiven = false;
          }
          notifyListeners();
        });
      } else {
        isLocationPerGiven = false;
      }
      notifyListeners();
    });

  }

  Future<bool> checkAppLocationGranted() async {
    PermissionStatus check = await location.hasPermission();
    if (check == PermissionStatus.granted) {
     return true;
    }
    return false;
  }

  requestAppLocationPermission() {
    location.requestPermission().then((isGiven) {
      if (isGiven == PermissionStatus.granted) {
        isLocationPerGiven = true;
      }else{
        isLocationPerGiven =false;
      }
      notifyListeners();
    });
  }

  Future<bool> checkLocationServiceEnabled() {
    return location.serviceEnabled();
  }

  requestLocationServiceToEnable() {
    location.requestService().then((isGiven) {
      isLocationSerGiven = isGiven;
      notifyListeners();
    });
  }
}

abstract class BaseBloc {
  void dispose();
}

