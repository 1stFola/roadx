
class RideRequestBinder {
  int journey_id;
  bool driver;
  int start_id;
  int destination_id;
  String carType;


  RideRequestBinder({
    this.journey_id,
    this.driver,
    this.start_id,
    this.destination_id,
    this.carType,
  });

  factory RideRequestBinder.fromJson(Map<String, dynamic> json) {
    return RideRequestBinder(
      journey_id: json['journey_id'],
      driver: json['driver'],
      start_id: json['start_id'],
      destination_id: json['destination_id'],
      carType: json['carType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'journey_id': journey_id,
    'driver': driver,
    'start_id': start_id,
    'destination_id': destination_id,
    'carType': carType,
  };
}

