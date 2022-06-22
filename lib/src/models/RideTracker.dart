import 'package:roadx/src/models/Enums/Enums.dart';
import 'package:roadx/src/models/RideRequest.dart';
import 'package:roadx/src/models/UserDetails.dart';

class RideTracker {
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

  RideTracker({
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

  factory RideTracker.fromJson(Map<String, dynamic> json) {
    return RideTracker(
      id: json['id'],
      user: json['user'] != null ? new UserDetails.fromJson(json['user']) : null,
      driverRequest: json['driverRequest'] != null ? new RideRequest.fromJson(json['driverRequest']) : null,
      driver_status: RideStatusHelper.getValue(json['driver_status']),
      passengerRequest: json['passengerRequest'] != null ? new RideRequest.fromJson(json['passengerRequest']) : null,
      passenger_status: RideStatusHelper.getValue(json['passenger_status']),
      distance: json['distance'] == null ? 0.0 : json['distance'],
      duration: json['duration'] == null ? 0 : json['distance'],
      category: json['category'],
      cost: json['cost'] == null ? 0.0 : json['distance'],
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

  static List<RideRequest> fromJsonList(List<dynamic> json) =>
      json.map((i) => RideRequest.fromJson(i)).toList();

}

