// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get_it/get_it.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as location;
// import 'package:roadx/src/blocs/MapModel.dart';
// import 'package:roadx/src/helpers/Utils.dart';
// import 'package:roadx/src/models/Enums/Enums.dart';
// import 'package:roadx/src/models/RideRequest.dart';
// import 'package:roadx/src/models/RideTracker.dart';
// import 'package:roadx/src/repositories/map.repository.dart';
// import 'package:roadx/src/values/colors.dart';
// import 'package:roadx/src/values/constants.dart';
// import 'package:roadx/src/widgets/lifecycle/services/socker_model.dart';
// import 'package:rxdart/rxdart.dart';
//
// class RideBookedBloc extends ChangeNotifier  {
//   static const TAG = "MapModel";
//   GoogleMapController _mapController;
//
//   GoogleMapController get mapController => _mapController;
//   GetIt getIt = GetIt.instance;
//
//   MapRepository mapRepo = new MapRepository();
//
//
//   // Location Object to get current Location
//   location.Location _location = location.Location();
//
//
//   String trackUserId = null;
//
//   RideRequest _rideRequest =new RideRequest();
//   RideRequest get rideRequest => _rideRequest;
//
//
//   LatLng _currentPosition = new LatLng(0,0);
//
//   // currentPosition Getter
//   LatLng get currentPosition => _currentPosition;
//
//   /// Origin Latitude and Longitude
//   LatLng originLatLng;
//
//   /// Destination Latitude and Longitude
//   LatLng destinationLatLng;
//
//   /// Default Camera Zoom
//   double currentZoom = 19;
//
//   // Driver currentDriver = DemoData.nearbyDrivers[1];
//   // LatLng driverLatLng = DemoData.nearbyDrivers[1].currentLocation;
//
//   RideStatus driverStatus = RideStatus.onWay;
//   final _driverStatusController = BehaviorSubject<RideTracker>();
//   Stream<RideTracker> get outDriverStatus => _driverStatusController.stream;
//
//   // Set of all the markers on the map
//   final Set<Marker> _markers = Set();
//
//   // Set of all the polyLines/routes on the map
//   final Set<Polyline> _polyLines = Set();
//
//   // Markers Getter
//   Set<Marker> get markers => _markers;
//
//   // PolyLines Getter
//   Set<Polyline> get polyLines => _polyLines;
//
//   MapBloc _mapBloc;
//
//
//   // RideBookedBloc({@required MapBloc mapBloc}) {
//   RideBookedBloc() {
//
//     // _driverStatusController.add(driverStatus);
//     _getUserLocation();
//     getDriverLocation();
//   }
//
//   Future<void> getDriverLocation() async {
//
//
//     // var trackDriver = getIt<SocketModel>().trackSelectedDriver;
//     // if(trackDriver != null && trackDriver.latitude != null && trackDriver.longitude != null){
//     //   LatLng latLng = new LatLng(trackDriver.latitude, trackDriver.longitude);
//     //   markers.add(Marker(
//     //       markerId: MarkerId(trackDriver.user_id.toString()),
//     //       infoWindow: InfoWindow(title: trackDriver.first_name),
//     //       position: latLng,
//     //       anchor: Offset(0.5, 0.5),
//     //       icon: BitmapDescriptor.fromBytes(
//     //           await Utils.getBytesFromAsset(
//     //           "assets/images/carIcon.png", 80))));
//     //     notifyListeners();
//     // }
//
//
//     // var trackSP = getIt<SocketModel>().userTracker;
//     // if(trackSP != null && trackSP.latitude != null && trackSP.longitude != null){
//     //   LatLng latLng = new LatLng(trackSP.latitude, trackSP.longitude);
//     //   markers.add(Marker(
//     //       markerId: MarkerId(trackSP.user_id.toString()),
//     //       infoWindow: InfoWindow(title: trackSP.first_name),
//     //       position: latLng,
//     //       anchor: Offset(0.5, 0.5),
//     //       icon: BitmapDescriptor.fromBytes(
//     //           await Utils.getBytesFromAsset(
//     //               "assets/images/pickupIcon.png", 80))));
//     //   notifyListeners();
//     // }
//
//
//   }
//
//
//
//     /// OnGoing Map
//   onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//     rootBundle.loadString('assets/mapStyle.txt').then((string) {
//       _mapController.setMapStyle(string);
//     });
//     addAllMarkers();
//     createOriginDestinationRoute();
//     createOriginDriverLocationRoute();
//     notifyListeners();
//   }
//
//   /// On Camera Moved
//   onCameraMove(CameraPosition position) {
//     currentZoom = position.zoom;
//     notifyListeners();
//   }
//
//   void createOriginDestinationRoute() async {
//     await mapRepo
//         .getRouteCoordinates(_mapBloc.pickupPosition, _mapBloc.destinationPosition)
//         .then((route) {
//       createCurrentRoute(route, Constants.currentRoutePolylineId,
//           backgroundColor, 3);
//       notifyListeners();
//     });
//   }
//
//   void createOriginDriverLocationRoute() async {
//     await mapRepo
//         .getRouteCoordinates(_mapBloc.pickupPosition, _mapBloc.destinationPosition)
//         .then((route) {
//       createCurrentRoute(route, Constants.driverOriginPolyId, Colors.green, 5);
//       notifyListeners();
//     });
//   }
//
//   ///Creating a Route
//   void createCurrentRoute(String encodedPoly, String polyId, Color color,
//       int width) {
//     _polyLines.add(Polyline(
//         polylineId: PolylineId(polyId),
//         width: width,
//         geodesic: true,
//         points: Utils.convertToLatLng(Utils.decodePoly(encodedPoly)),
//         color: color));
//     notifyListeners();
//   }
//
//   void addAllMarkers() async {
//     _markers.add(Marker(
//         markerId: MarkerId(Constants.pickupMarkerId),
//         position: _mapBloc.pickupPosition,
//         flat: true,
//         icon: BitmapDescriptor.fromBytes(
//           await Utils.getBytesFromAsset("images/pickupIcon.png", 70),
//         )));
//     _markers.add(Marker(
//         markerId: MarkerId(Constants.destinationMarkerId),
//         position: _mapBloc.destinationPosition,
//         flat: true,
//         icon: BitmapDescriptor.fromBytes(
//           await Utils.getBytesFromAsset("assets/images/destinationIcon.png", 70),
//         )));
//
//     notifyListeners();
//   }
//
//
//
//
//   void _getUserLocation() async {
//
//     _location.getLocation().then((data) async {
//       _currentPosition = LatLng(data.latitude, data.longitude);
//
//       if (_currentPosition == null) return;
//       _markers.add(Marker(
//           markerId: MarkerId(Constants.pickupMarkerId),
//           position: _currentPosition,
//           draggable: true,
// //          onDragEnd: onPickupMarkerDragged,
//           anchor: Offset(0.5, 0.5),
//           icon: BitmapDescriptor.fromBytes(
//               await Utils.getBytesFromAsset("assets/images/pickupIcon.png", 80))));
//       notifyListeners();
//     });
//   }
//
//
//
//   setRideRequest(RideRequest rideRequest) {
//     _rideRequest = rideRequest;
//     notifyListeners();
//   }
//
//   joinTrackUserId(int trackUserId, int trackRideTracker_id) {
//     this.trackUserId = trackUserId.toString();
//     var data = {
//       'status' : 'join',
//       'user_id' : this.trackUserId,
//       'tracker_id' : trackRideTracker_id.toString()
//     };
//     getIt<SocketModel>().socket.emit("track_user", data);
//     notifyListeners();
//   }
//
//   removeTrackUserId(int trackUserId) {
//     if(trackUserId != null) {
//       var data = {
//         'status': 'remove',
//         'user_id': trackUserId
//       };
//       getIt<SocketModel>().socket.emit("track_user", data);
//       notifyListeners();
//     }
//   }
//
//
//
// }
//
//
// // abstract class BaseBloc {
// //   void dispose();
// // }
