import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadx/src/helpers/http/http.helper.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/models/BusStop.dart';
import 'package:roadx/src/models/RideRequest.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/models/binder/BindRideRequest.dart';
import 'package:roadx/src/models/response.model.dart';
import 'package:roadx/src/values/constants.dart';
import './base/endpoints.dart' as Endpoints;

class MapService {
  Future<ResponseModel> getAutoCompleteBusStops(
      String search, double latitude, double longitude) async {
    ResponseModel response = ResponseModel();

    final String url = Endpoints.map.location+"?street=${search}&latitude=${latitude}&longitude=${longitude}";


    Map<String, dynamic> queryParameters = new Map();
    queryParameters['street'] = search;
    queryParameters['latitude'] = latitude;
    queryParameters['longitude'] = longitude;

    final retAuth = HttpHelper.get(url, queryParameters: queryParameters);

    await retAuth.then((res) {
      response.status = true;
      response.data = res.data;
      response.message = res.statusMessage;
    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }

  Future<ResponseModel> autoCompleteBusstop(String busstop) async {
    ResponseModel response = ResponseModel();

    final String url = Endpoints.map.autoComplete;

    Map<String, dynamic> queryParameters = new Map();
    queryParameters['busstop'] = busstop;

    final retAuth = HttpHelper.get(url, queryParameters: queryParameters);

    await retAuth.then((res) {
      response.data = BusStop.fromJsonList(res.data);
      response.status = true;
      response.message = res.statusMessage;

    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }

  Future<ResponseModel> destinationPoint(String busstop, String pickup_busstop) async {
    ResponseModel response = ResponseModel();

    final String url = Endpoints.map.destinationPoint+"/"+ pickup_busstop;

    Map<String, dynamic> queryParameters = new Map();
    queryParameters['busstop'] = busstop;

    final retAuth = HttpHelper.get(url, queryParameters : queryParameters);

    await retAuth.then((res) {
      response.data = BusStop.fromJsonList(res.data);
      response.status = true;
      response.message = res.statusMessage;

    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }

  Future<ResponseModel> nearestBusstopCoordinate(LatLng latLng ) async {
    ResponseModel response = ResponseModel();

    final String url = Endpoints.map.nearestBusstop;


    Map<String, dynamic> queryParameters = new Map();
    queryParameters['latitude'] = latLng.latitude;
    queryParameters['longitude'] = latLng.longitude;

    final retAuth = HttpHelper.get(url, queryParameters: queryParameters);

    await retAuth.then((res) {
      response.data = BusStop.fromJsonList(res.data);
      response.status = true;
      response.message = res.statusMessage;

    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }

  Future<ResponseModel> rideRequest(BindRideRequest bindRideRequest  ) async {
    ResponseModel response = ResponseModel();

    final String url = Endpoints.ride.rideRequest;

    final retAuth = HttpHelper.post(url, body: bindRideRequest);

    await retAuth.then((res) {
      response.data = RideRequest.fromJson(res.data);
      response.status = true;
    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }

  Future<ResponseModel> getRouteCoordinates(LatLng l1, LatLng l2  ) async {
    ResponseModel response = ResponseModel();

    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=${mapApiKey}";

    final retAuth = HttpHelper.get(url);

    await retAuth.then((res) {
      response.data = res.data["routes"][0]["overview_polyline"]["points"];
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
