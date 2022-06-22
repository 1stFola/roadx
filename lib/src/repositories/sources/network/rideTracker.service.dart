import 'package:roadx/src/helpers/http/http.helper.dart';
import 'package:roadx/src/models/RideTracker.dart';
import 'package:roadx/src/models/binder/RideTrackerBinder.dart';
import 'package:roadx/src/models/response.model.dart';
import './base/endpoints.dart' as Endpoints;

class RideTrackerService {

  Future<ResponseModel> create(RideTrackerBinder rideTrackerBinder) async {
    ResponseModel response = ResponseModel();
    final String url = Endpoints.ride.rideTracker;
    final retAuth = HttpHelper.post(url, body: rideTrackerBinder);
    await retAuth.then((res) {
      response.status = true;
      response.data = RideTracker.fromJson(res.data);
      // response.message = res.statusMessage;
    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });
    return response;
  }


  Future<ResponseModel> update(RideTracker rideTrackerBinder) async {
    ResponseModel response = ResponseModel();
    final String url = Endpoints.ride.rideTracker+"/"+rideTrackerBinder.id.toString();
    final retAuth = HttpHelper.put(url, body: rideTrackerBinder);
    await retAuth.then((res) {
      response.status = true;
      response.data = RideTracker.fromJson(res.data);
      response.message = res.statusMessage;
    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }


  Future<ResponseModel> getTracker() async {
    ResponseModel response = ResponseModel();

    final String url = Endpoints.ride.rideTracker;

    final retAuth = HttpHelper.get(url);

    await retAuth.then((res) {
      response.data = RideTracker.fromJsonList(res.data);
      response.status = true;
      response.message = res.statusMessage;

    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }

  Future<ResponseModel> delete(int passenger_request_id, int driver_request_id) async {
    ResponseModel response = ResponseModel();

    final String url = Endpoints.ride.rideTracker;

    Map<String, dynamic> queryParameters = new Map();
    queryParameters['passenger_request_id'] = passenger_request_id;
    queryParameters['driver_request_id'] = driver_request_id;

    final retAuth = HttpHelper.delete(url, queryParameters: queryParameters);

    await retAuth.then((res) {
      response.data = res.data;
      response.status = true;
    }).catchError((e) {
      response.status = false;
      response.data = e;
      response.message = e.message;
    });

    return response;
  }


}
