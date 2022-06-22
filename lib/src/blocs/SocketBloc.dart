import 'package:flutter/widgets.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/models/RideTracker.dart';
import 'package:roadx/src/repositories/sources/network/base/base_url.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:rxdart/rxdart.dart';


class SocketBloc extends ChangeNotifier {
  IO.Socket socket;

  final _rideTrackerController = BehaviorSubject<RideTracker>();
  Function(RideTracker) get rideTrackerChanged => _rideTrackerController.sink.add;
  Stream<RideTracker> get rideTracker => _rideTrackerController.stream;


  SocketBloc() {
    getContent();
  }



  getContent() async {
    String token = await StorageHelper.get(StorageKeys.token);
    this.socket = io(socket_url,
        <String, dynamic>{
          // 'transports': ['websocket', 'polling'],
          'transports' : ['websocket'],
          'upgrade': false,
          'autoConnect': true,
          'extraHeaders': {'user-key': token}
        });

    this.socket.connect();

    this.socket.on(
        "connect",
            (_) => {

          notifyListeners()
        });
    this.socket.on(
        "disconnect",
            (_) => {

          notifyListeners()
        });

    this.socket.on(
        "error",
            (_) => {

          notifyListeners()
        });


    this.socket.on(
        "driver_update",
            (status) => {

          notifyListeners()
        });

    this.socket.on(
        "passenger_update",
            (status) => {

          notifyListeners()
        });


    this.socket.on(
        "ride_tracker_status",
            (status) => {

              _rideTrackerController.add(RideTracker.fromJson(status)),

              notifyListeners()
        });


    // this.socket.on(
    //     "passenger_approved_update",
    //         (status) => {
    //           _userTracker = UserTracker.fromJson(status),
    //           notifyListeners()
    //     });


    this.socket.on(
        "driver_approved_update", (status) => {

      notifyListeners()
    });









    // this.socket.on(
    //     "track_selected_passengers",
    //         (status) => {
    //           _userTracker = UserTracker.fromJson(status),
    //           notifyListeners()
    //     });
    this.socket.on(
        "available_passenger",
            (status) => {

          notifyListeners()
        });
    this.socket.on(
        "available_driver",
            (status) => {

          notifyListeners()
        });

    this.socket.on('ping', (data) => {
      this.socket.emit('pong', { 'beat': 1} )
    });
  }


  setRideTracker(RideTracker rideTracker){
    _rideTrackerController.add(rideTracker);
  }

}

abstract class BaseBloc {
  void dispose();
}

