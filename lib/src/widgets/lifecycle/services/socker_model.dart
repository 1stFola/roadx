import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/models/RideRequest.dart';
import 'package:roadx/src/models/RideTracker.dart';
import 'package:roadx/src/models/socket/Eventer.dart';
import 'package:roadx/src/models/socket/TrackerAllPassengers.dart';
import 'package:roadx/src/models/socket/UserPosition.dart';
import 'package:rxdart/rxdart.dart';
import '../../../repositories/sources/network/base/base_url.dart' as BASE_URL;



import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:socket_io_client/socket_io_client.dart';


abstract class SocketModel extends ChangeNotifier {
  Socket get socket;
  Stream<List<TrackerPassenger>>   get trackPassengers;


  StringInEvent get stringInEvent;

  RideTracker  get rideTracker;

  UserPosition  get trackDriver;
  UserPosition  get trackerPassenger;

  // UserTracker  get userTracker;
}

class AppModelImplementation extends SocketModel {
  List<TrackerPassenger> array = new List<TrackerPassenger>();
  GetIt getIt = GetIt.instance;
  IO.Socket socket;
  StringInEvent _stringInEvent = new StringInEvent("");
  // DriverStatus _driverStatus = DriverStatus.Booked;
  RideTracker _rideTraker = new RideTracker();
  UserPosition _trackerDriver = new UserPosition();
  UserPosition _trackerPassenger = new UserPosition();


  // UserTracker _userTracker = new UserTracker();
  RideRequest _available_passenger = new RideRequest();
  RideRequest _available_driver = new RideRequest();


  final _trackerPassengerController =  BehaviorSubject<List<TrackerPassenger>>();
  Stream<List<TrackerPassenger>> get _trackerPassengers => _trackerPassengerController.stream;
  List<TrackerPassenger> trackerPassengerList = new List<TrackerPassenger>();


  @override
  UserPosition get trackDriver => _trackerDriver;

  @override
  UserPosition get trackerPassenger => _trackerPassenger;

  @override
  Stream<List<TrackerPassenger>> get trackPassengers => _trackerPassengers;


  @override
  RideRequest get availablePassenger => _available_passenger;
  @override
  RideRequest get availableDriver => _available_driver;

  // @override
  // UserTracker get userTracker => _userTracker;



  @override
  StringInEvent get stringInEvent => _stringInEvent;

  @override
  RideTracker get rideTracker => _rideTraker;

  AppModelImplementation(){
    getContent();
    Future.delayed(Duration(seconds: 3)).then((_) => getIt.signalReady(this));
  }

  getContent() async {
    String token = await StorageHelper.get(StorageKeys.token);
    this.socket = io(BASE_URL.socket_url,
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
              _stringInEvent = StringInEvent("connect"),
            notifyListeners()
        });
    this.socket.on(
        "disconnect",
            (_) => {
            _stringInEvent = StringInEvent("disconnect"),
              notifyListeners()
            });

    this.socket.on(
        "error",
            (_) => {
              _stringInEvent = StringInEvent("error"),
              notifyListeners()
        });


    this.socket.on(
        "driver_update",
            (status) => {
              _trackerDriver = UserPosition.fromJson(status) ,
              notifyListeners()
        });

    this.socket.on(
        "passenger_update",
            (status) => {
              _trackerPassenger = UserPosition.fromJson(status) ,
              notifyListeners()
        });


    this.socket.on(
        "ride_tracker_status",
            (status) => {
            _rideTraker = RideTracker.fromJson(status),
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
              trackerPassengerList = trackerPassengerList+TrackerPassenger.fromJsonList(status),
            _trackerPassengerController.sink.add(trackerPassengerList),
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

              _available_passenger = RideRequest.fromJson(status),
              notifyListeners()
        });
    this.socket.on(
        "available_driver",
            (status) => {
              _available_driver = RideRequest.fromJson(status),
              notifyListeners()
        });

    this.socket.on('ping', (data) => {
    this.socket.emit('pong', { 'beat': 1} )
    });
  }

}

