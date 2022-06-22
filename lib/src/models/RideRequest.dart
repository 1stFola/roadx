

import 'package:roadx/src/models/BusStop.dart';
import 'package:roadx/src/models/Journey.dart';
import 'package:roadx/src/models/UserDetails.dart';

class RideRequest {
  int id;
  UserDetails user;
  bool driver;
  Journey journey;
  BusStop destination;
  BusStop start;
  String carType;


  RideRequest({
    this.id,
    this.user,
    this.driver,
    this.journey,
    this.destination,
    this.start,
    this.carType,
  });

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
      id: json['id'],
      user: json['user'] != null ? new UserDetails.fromJson(json['user']) : null,
      driver: json['driver'] == 1 ? true : false,
      journey: json['journey'] != null ? new Journey.fromJson(json['journey']) : null,
      destination: json['destination'] != null ? new BusStop.fromJson(json['destination']) : null,
      start: json['start'] != null ? new BusStop.fromJson(json['start']) : null,
      carType: json['carType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user,
    'driver': driver,
    'journey': journey,
    'destination': destination,
    'start': start,
    'carType': carType,
  };

  static List<RideRequest> fromJsonList(List<dynamic> json) =>
      json.map((i) => RideRequest.fromJson(i)).toList();

}

