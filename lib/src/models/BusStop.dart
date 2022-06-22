
class BusStop {
  int id;
  String place_id;
  int journey_id;
  String address;
  String formatted_address;
  double latitude;
  double longitude;

  BusStop({
    this.id,
    this.place_id,
    this.journey_id,
    this.address,
    this.formatted_address,
    this.latitude,
    this.longitude,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      id: json['id'],
      place_id: json['place_id'],
      journey_id: json['journey_id'],
      address: json['address'],
      formatted_address: json['formatted_address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'place_id': place_id,
        'journey_id': journey_id,
        'address': address,
        'formatted_address': formatted_address,
        'latitude': latitude,
        'longitude': longitude,
      };

  static List<BusStop> fromJsonList(List<dynamic> json) =>
      json.map((i) => BusStop.fromJson(i)).toList();

}
