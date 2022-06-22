
import 'package:roadx/src/models/BusStop.dart';

class AddressInfo {
  String place_id;
  String formatted_address;
  double latitude;
  double longitude;
  String street;
  List<BusStop> busStops;

  AddressInfo({
    this.place_id,
    this.formatted_address,
    this.latitude,
    this.longitude,
    this.street,
    this.busStops,
  });

  factory AddressInfo.fromJson(Map<String, dynamic> json) {
    List busStops = json['busStops'];
    List<BusStop> portfolioLists = json['busStops'] != null
        ? busStops.map((row) => new BusStop.fromJson(row)).toList()
        : [];

    return AddressInfo(
      place_id: json['place_id'],
      formatted_address: json['formatted_address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      street: json['street'],
      busStops: busStops,
    );
  }

  Map<String, dynamic> toJson() => {
        'place_id': place_id,
        'formatted_address': formatted_address,
        'latitude': latitude,
        'longitude': longitude,
        'street': street,
        'busStops': busStops,
      };
}
