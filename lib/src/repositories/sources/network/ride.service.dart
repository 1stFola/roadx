import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadx/src/helpers/http/http.helper.dart';
import 'package:roadx/src/models/BusStop.dart';
import 'package:roadx/src/models/RideRequest.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/models/binder/BindRideRequest.dart';
import 'package:roadx/src/models/binder/RideRequestBinder.dart';
import 'package:roadx/src/models/response.model.dart';
import 'package:roadx/src/values/constants.dart';
import './base/endpoints.dart' as Endpoints;

class RideService {
  Future<ResponseModel> getAvailableRide(RideRequestBinder rideRequest) async {
    ResponseModel response = ResponseModel();

    final String url = Endpoints.ride.getAvailableRide;
    final retAuth = HttpHelper.post(url, body: rideRequest);

    await retAuth.then((res) {
      response.status = true;
      response.data = RideRequest.fromJsonList(res.data);
      response.message = res.statusMessage;
    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }


  Future<ResponseModel> getOnboardPassengers() async {
    ResponseModel response = ResponseModel();

    final String url = Endpoints.ride.getOnboardPassengers;


    final retAuth = HttpHelper.get(url);

    await retAuth.then((res) {
      response.data = UserDetails.fromJsonList(res.data);
      response.status = true;
      response.message = res.statusMessage;

    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }



  Future<ResponseModel> createRideRequest(RideRequest rideRequest) async {
    ResponseModel response = ResponseModel();

    final String url = Endpoints.ride.rideRequest;
    final retAuth = HttpHelper.post(url, body: rideRequest);

    await retAuth.then((res) {
      response.status = true;
      response.data = RideRequest.fromJsonList(res.data);
      response.message = res.statusMessage;
    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }

  Future<ResponseModel> getHistory() async {
    ResponseModel response = ResponseModel();

    final String url = Endpoints.ride.rideRequest;

    final retAuth = HttpHelper.get(url);

    await retAuth.then((res) {
      response.data = RideRequest.fromJsonList(res.data);
      response.status = true;
      response.message = res.statusMessage;

    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }

  Future<ResponseModel> delete(int delete_id, ) async {
    ResponseModel response = ResponseModel();

    final String url = Endpoints.ride.rideRequest+"?id="+delete_id.toString();

    final retAuth = HttpHelper.delete(url);

    await retAuth.then((res) {
      response.data = res.data;
      response.status = true;
      response.message = res.statusMessage;

    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }


}
