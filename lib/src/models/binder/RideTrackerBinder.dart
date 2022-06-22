
class RideTrackerBinder {
  int driver_request_id;
  String driver_status;
  int passenger_request_id;
  String passenger_status;
  double distance;
  int duration;
  String category;
  double cost;


  RideTrackerBinder({
    this.driver_request_id,
    this.driver_status,
    this.passenger_request_id,
    this.passenger_status,
    this.distance,
    this.duration,
    this.category,
    this.cost,
  });

  factory RideTrackerBinder.fromJson(Map<String, dynamic> json) {
    return RideTrackerBinder(
      driver_request_id: json['driver_request_id'],
      driver_status: json['driver_status'],
      passenger_request_id: json['passenger_request_id'],
      passenger_status: json['passenger_status'],
      distance: json['distance'],
      duration: json['duration'],
      category: json['category'],
      cost: json['cost'],
    );
  }

  Map<String, dynamic> toJson() => {
    'driver_request_id': driver_request_id,
    'driver_status': driver_status,
    'passenger_request_id': passenger_request_id,
    'passenger_status': passenger_status,
    'distance': distance,
    'duration': duration,
    'category': category,
    'cost': cost,
  };
}

