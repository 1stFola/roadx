import 'package:roadx/src/helpers/connection.helper.dart';
import 'package:roadx/src/models/RideRequest.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/models/binder/RideRequestBinder.dart';
import 'package:roadx/src/models/response.model.dart';
import 'package:roadx/src/repositories/sources/network/ride.service.dart';

class RideRepository {
  RideService api = RideService();


  Future<List<RideRequest>> getAvailableRide(RideRequestBinder rideRequest) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.getAvailableRide(rideRequest);
    } else {
      response.message = "Device offline";
    }

    return response.data;
  }



  Future<RideRequest> createRideRequest(RideRequest ride) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.createRideRequest(ride);
    } else {
      response.message = "Device offline";
    }

    return response.data;
  }


  Future<List<RideRequest>> getHistory() async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.getHistory();
    } else {
      response.message = "Device offline";
    }

    return response.data;
  }


  Future<ResponseModel> delete(int delete_id ) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.delete(delete_id);
    } else {
      response.message = "Device offline";
    }

    return response;
  }

  Future<List<RideRequest>> getOnboardPassengers( ) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.getOnboardPassengers();
    } else {
      response.message = "Device offline";
    }

    return response.data;
  }


}
