import 'package:geocoder/geocoder.dart';
import 'package:roadx/src/helpers/connection.helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:roadx/src/models/AddressInfo.dart';
import 'package:roadx/src/models/BusStop.dart';
import 'package:roadx/src/models/RideRequest.dart';
import 'package:roadx/src/models/binder/BindRideRequest.dart';
import 'package:roadx/src/models/response.model.dart';
import 'package:roadx/src/repositories/sources/network/map.service.dart';

class MapRepository {
  MapService api = MapService();


  Future<AddressInfo> getAutoCompleteBusStops(
      String search, double latitude, double longitude) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.getAutoCompleteBusStops(search, latitude, longitude);
    } else {
      response.message = "Device offline";
    }

    return response.data;
  }


  Future<List<BusStop>> autoCompleteBusstop(String busstop) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.autoCompleteBusstop(busstop);
    } else {
      response.message = "Device offline";
    }

    return response.data;
  }


  Future<List<BusStop>> destinationPoint(String busstop, String pickup_busstop ) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.destinationPoint(busstop, pickup_busstop);
    } else {
      response.message = "Device offline";
    }

    return response.data;
  }

  Future<List<BusStop>> nearestBusstopCoordinate(LatLng latLng ) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.nearestBusstopCoordinate(latLng);
    } else {
      response.message = "Device offline";
    }

    return response.data;
  }



  Future<RideRequest> rideRequest(BindRideRequest bindRideRequest ) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.rideRequest(bindRideRequest);
    } else {
      response.message = "Device offline";
    }

    return response.data;
  }


  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    ResponseModel response = ResponseModel();

    final hasConnection = await ConnectionHelper.hasConnection();

    if (hasConnection) {
      response = await this.api.getRouteCoordinates(l1, l2);
    } else {
      response.message = "Device offline";
    }

    return response.data;
  }




  Future<String> getPlaceNameFromLatLng(LatLng latLng) async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(Coordinates(latLng.latitude, latLng.longitude ));
    var placemark = addresses.first;
    return placemark.addressLine +
        ", " +
        placemark.locality +
        ", " +
        placemark.countryName;
  }
}
