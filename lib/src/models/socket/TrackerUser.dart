import 'package:roadx/src/models/Enums/Enums.dart';
import 'package:roadx/src/models/RideRequest.dart';
import 'package:roadx/src/models/UserDetails.dart';

class TrackerUser {
  int id;
  UserDetails user;
  RideRequest driverRequest;
  RideStatus driver_status;
  RideRequest passengerRequest;
  RideStatus passenger_status;
  double distance;
  int duration;
  String category;
  double cost;

  TrackerUser({
    this.id,
    this.user,
    this.driverRequest,
    this.driver_status,
    this.passengerRequest,
    this.passenger_status,
    this.distance,
    this.duration,
    this.category,
    this.cost,
  });

  factory TrackerUser.fromJson(Map<String, dynamic> json) {
    return TrackerUser(
      id: json['id'],
      user: json['user'] != null ? new UserDetails.fromJson(json['user']) : null,
      driverRequest: json['driverRequest'] != null ? new RideRequest.fromJson(json['driverRequest']) : null,
      driver_status: json['driver_status'] != null ?  RideStatus.values[json['driver_status']] : null,
      passengerRequest: json['passengerRequest'] != null ? new RideRequest.fromJson(json['passengerRequest']) : null,
      passenger_status: json['passenger_status'] != null ?  RideStatus.values[json['passenger_status']] : null,
      distance: json['distance'],
      duration: json['duration'],
      category: json['category'],
      cost: json['cost'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user,
    'driverRequest': driverRequest,
    'driver_status': driver_status,
    'passengerRequest': passengerRequest,
    'passenger_status': passenger_status,
    'distance': distance,
    'duration': duration,
    'category': category,
    'cost': cost,
  };

  static List<TrackerUser> fromJsonList(List<dynamic> json) =>
      json.map((i) => TrackerUser.fromJson(i)).toList();

}

