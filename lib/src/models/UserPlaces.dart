import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadx/src/models/Enums/Enums.dart';

class UserPlaces {
  final String place_id;
  final String name;
  final double latitude;
  final double longitude;
  final int minutesFar;
  final UserLocationType locationType;

  const UserPlaces({this.place_id, this.name, this.latitude,  this.longitude, this.locationType, this.minutesFar});


  factory UserPlaces.fromJson(Map<String, dynamic> json) {
    return UserPlaces(
      place_id: json['place_id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      minutesFar: json['minutesFar'],
      locationType: json['locationType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'place_id': place_id,
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'minutesFar': minutesFar,
    'locationType': locationType,
  };
}
