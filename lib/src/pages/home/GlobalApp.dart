import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roadx/src/blocs/SocketBloc.dart';
import 'package:roadx/src/blocs/auth.bloc.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/models/Enums/Enums.dart';
import 'package:roadx/src/models/RideTracker.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/pages/onGoingRide/tripTracker.dart';
import 'package:roadx/src/widgets/ModelUtil.dart';
import 'package:roadx/src/widgets/toast.dart';
import 'package:location/location.dart' as location;


class GlobalApp extends StatefulWidget {
  Widget child;

  GlobalApp({Key key, this.child}) : super(key: key);

  @override
  createState() => _GlobalAppState();
}

class _GlobalAppState extends State<GlobalApp> {
  SocketBloc socketBloc;
  AuthBloc authBloc;
  RideTracker rideTracker;
  location.Location _location = location.Location();

  @override
  void initState() {
    super.initState();
    modal();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    socketBloc = Provider.of<SocketBloc>(context);
    authBloc = Provider.of<AuthBloc>(context);
    modal();
  }

  @override
  Future<void> modal() async {

    bool isDriver = await StorageHelper.getBool(StorageKeys.isDriver);

    var userData = await StorageHelper.get(StorageKeys.client);
    if (userData != null && userData != "") {
      var userDetails = UserDetails.fromJson(jsonDecode(userData));
      Future.delayed(const Duration(seconds: 5), () {
        _location.onLocationChanged.listen((event) async {
          Map<String, dynamic> attributeMap = new Map<String, dynamic>();
          attributeMap["latitude"] = event.latitude;
          attributeMap["longitude"] = event.longitude;
          attributeMap["user_id"] = userDetails.id;
          attributeMap["isDriver"] = isDriver;
          attributeMap["first_name"] = userDetails.first_name;
          attributeMap["last_name"] = userDetails.last_name;
          socketBloc.socket.emit("current_position", attributeMap);
        });
      });
    }
    print('LocationService Started');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: socketBloc.rideTracker,
          builder: (BuildContext context, snapshot) {
            UserDetails user = snapshot.data;
            return FutureBuilder(
                future: StorageHelper.get(StorageKeys.rideRequest),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    rideTracker = RideTracker.fromJson(jsonDecode(snapshot.data));
                  }

                  return StreamBuilder(
                    stream: socketBloc.rideTracker,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        rideTracker = snapshot.data;
                      }

                      if (rideTracker != null) {
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          if (rideTracker != null && rideTracker.user != null && user.id == rideTracker.user.id) {
                            if (rideTracker.passenger_status ==
                                    RideStatus.approved &&
                                rideTracker.driver_status ==
                                    RideStatus.approved) {
                              StorageHelper.set(StorageKeys.rideRequest,
                                  jsonEncode(rideTracker));
                            } else if (rideTracker != null && rideTracker.passenger_status != null && rideTracker.passenger_status ==
                                    RideStatus.approved &&
                                rideTracker.driver_status ==
                                    RideStatus.cancel) {
                              CustomToast.show( rideTracker.driverRequest.user.first_name + " has cancelled your request");
                            } else if(rideTracker != null) {
                              Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          new TripTrackerWidget()));
                            }
                          } else {
                            if (rideTracker.passenger_status ==
                                    RideStatus.approved &&
                                rideTracker.driver_status ==
                                    RideStatus.approved) {
                              ModelUtil.userRequestNotification(
                                  context, snapshot.data);
                            } else if (rideTracker.passenger_status ==
                                    RideStatus.cancel &&
                                rideTracker.driver_status ==
                                    RideStatus.approved) {
                              CustomToast.show( rideTracker.passengerRequest.user.first_name + " has cancelled the request");
                            }
                          }
                        });
                      }

                      return widget.child;
                    },
                  );
                });
          }),
      // child: ,
    );
  }
}
