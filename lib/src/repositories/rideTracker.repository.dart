import 'package:roadx/src/helpers/connection.helper.dart';
import 'package:roadx/src/models/RideTracker.dart';
import 'package:roadx/src/models/binder/RideTrackerBinder.dart';
import 'package:roadx/src/models/response.model.dart';
import 'package:roadx/src/repositories/sources/network/rideTracker.service.dart';

class RideTrackerRepository {
  RideTrackerService api = RideTrackerService();


  Future<RideTracker> create(RideTrackerBinder rideRequest) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.create(rideRequest);
    } else {
      response.message = "Device offline";
    }

    return response.data;
  }


  Future<RideTracker> update(RideTracker rideRequest) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.update(rideRequest);
    } else {
      response.message = "Device offline";
    }

    return response.data;
  }



  Future<List<RideTracker>> getTracker() async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.getTracker();
    } else {
      response.message = "Device offline";
    }

    return response.data;
  }



  Future<ResponseModel> delete(int passenger_request_id, int driver_request_id) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.delete(passenger_request_id, driver_request_id);
    } else {
      response.message = "Device offline";
    }

    return response;
  }


}
