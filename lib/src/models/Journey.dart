import 'package:google_maps_flutter/google_maps_flutter.dart';

class Journey {
  int id;
  String start;
  String destination;
  String description;

  Journey({
    this.id,
    this.start,
    this.destination,
    this.description,
  });


  factory Journey.fromJson(Map<String, dynamic> json) {
    return Journey(
      id: json['id'],
      start: json['start'],
      destination: json['destination'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'destination': destination,
    'description': description,
  };

}

