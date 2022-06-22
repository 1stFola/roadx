class BindRideRequest {
   int journey_id;
   int start_id;
   int destination_id;
   bool driver;
   String carType;

   BindRideRequest({this.journey_id, this.start_id, this.destination_id, this.driver, this.carType});

  factory BindRideRequest.fromJson(Map<String, dynamic> json) {
    return BindRideRequest(
        journey_id: json['journey_id'], start_id: json['start_id'], destination_id: json['destination_id'], driver: json['driver'], carType: json['carType']);
  }

  Map<String, dynamic> toJson() => {'journey_id': journey_id, 'start_id': start_id, 'destination_id': destination_id, 'driver': driver, 'carType': carType};
}
