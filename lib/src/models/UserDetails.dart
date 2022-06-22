

import 'package:roadx/src/models/UserPlaces.dart';

class UserDetails {
  int id;
  String token;
  String image;
  String fcmToken;
  String label;
  String first_name;
  String last_name;
  String email;
  String password;
  String phone;
  String address;
  String workplace;
  String number_plate;
  String vehicle_category;
  String vehicle_model;
  String hasAc;
  int rate;
  double latitude;
  double longitude;
  bool isDriver;
  String ongoingRide;
  List<String> previousRides;
  List<UserPlaces> favouritePlaces;


  UserDetails({
    this.id,
    this.token,
    this.image,
    this.fcmToken,
    this.label,
    this.first_name,
    this.last_name,
    this.email,
    this.password,
    this.phone,
    this.address,
    this.workplace,
    this.number_plate,
    this.vehicle_category,
    this.vehicle_model,
    this.rate,
    this.latitude,
    this.longitude,
    this.isDriver,
    this.ongoingRide,
    this.previousRides,
    this.favouritePlaces,
    this.hasAc,
  });


  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      token: json['token'],
      image: json['image'],
      fcmToken: json['fcmToken'],
      label: json['label'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      address: json['address'],
      workplace: json['workplace'],
      number_plate: json['number_plate'],
      vehicle_category: json['vehicle_category'],
      vehicle_model: json['vehicle_model'],
      rate: json['rate'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isDriver: json['isDriver'],
      ongoingRide: json['ongoingRide'],
      hasAc: json['hasAC'],
     previousRides:json['previousRides'] != null ? new List<String>.from(
         json['previousRides'].map((movie) =>  Content.fromJson(movie))) : [],
     favouritePlaces: json['favouritePlaces'] != null ? new List<UserPlaces>.from(
         json['favouritePlaces'].map((movie) =>  UserPlaces.fromJson(movie))) : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'token': token,
    'image': image,
    'fcmToken': fcmToken,
    'label': label,
    'first_name': first_name,
    'last_name': last_name,
    'email': email,
    'password': password,
    'phone': phone,
    'address': address,
    'workplace': workplace,
    'number_plate': number_plate,
    'vehicle_category': vehicle_category,
    'vehicle_model': vehicle_model,
    'rate': rate,
    'latitude': latitude,
    'longitude': longitude,
    'isDriver': isDriver,
    'ongoingRide': ongoingRide,
    'favouritePlaces': favouritePlaces,
    'hasAc': hasAc,
    'previousRides': previousRides,
    'favouritePlaces': favouritePlaces,
  };


  static List<UserDetails> fromJsonList(List<dynamic> json) =>
      json.map((i) => UserDetails.fromJson(i)).toList();


}

class Content {
  String content;

   Content({
    this.content,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    content: json['content'];
  }

  Map<String, dynamic> toJson() => {
    'content': content,
  };
}
