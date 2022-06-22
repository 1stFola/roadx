
import 'package:roadx/src/models/CarTypeMenu.dart';
import 'package:roadx/src/models/UserDetails.dart';

final String terms_and_conditions = "https://www.google.com";
final String privacy_and_priviledge = "https://www.google.com";
final String mapApiKey = 'AIzaSyBHp0CroL2Myi19nY9rbQhoV-I7irLegnY';


class Settings {
  static const String apiUrl = "http://192.168.43.127/api/mobile/";
//  static const String socketUrl = "http://192.168.43.127:3000";
  static const String socketUrl = "https://socketio-chat-h9jt.herokuapp.com/";
}



class Constants {
  static const destinationMarkerId = "DestinationMarker";
  static const pickupMarkerId = "PickupMarker";
  static const currentLocationMarkerId = "currentLocationMarker";
  static const currentRoutePolylineId = "currentRoutePolyline";
  static const driverMarkerId = "CurrentDriverMarker";
  static const driverOriginPolyId = "driverOriginPolyLine";


  static List<CarTypeMenu> typesOfCar = [
    CarTypeMenu("assets/images/standard.png", "4 Seats",
        "Classic", "B"),
    CarTypeMenu("assets/images/general.png",
        "7 Seats", "Standard", "B"),
//    CarTypeMenu("images/sedanCarIcon.png",
//        " Car with extra leg Space and Storage", RideType.Sedan),
//    CarTypeMenu("images/suvCarIcon.png",
//        " Suv's for travelling with big Family", RideType.Suv),
//    CarTypeMenu("images/luxuryCarIcon.png", "Luxury Cars for any occasion",
//        RideType.Luxury),
  ];
}


