import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:roadx/src/helpers/Utils.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/models/AddressInfo.dart';
import 'package:roadx/src/models/BusStop.dart';
import 'package:roadx/src/models/Enums/Enums.dart';
import 'package:roadx/src/models/RideRequest.dart';
import 'package:roadx/src/models/RideTracker.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/models/binder/BindRideRequest.dart';
import 'package:roadx/src/models/binder/RideRequestBinder.dart';
import 'package:roadx/src/models/binder/RideTrackerBinder.dart';
import 'package:roadx/src/models/socket/UserPosition.dart';
import 'package:roadx/src/repositories/map.repository.dart';
import 'package:roadx/src/repositories/ride.repository.dart';
import 'package:roadx/src/repositories/rideTracker.repository.dart';
import 'package:roadx/src/values/colors.dart';
import 'package:roadx/src/values/constants.dart';
import 'package:roadx/src/widgets/lifecycle/services/socker_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart';

/// A viewModel kind of class for handling Map related information and updating.
/// We are using Provider with notifyListeners() for the sake of simplicity but will update with dynamic approach
/// Provider : https://pub.dev/packages/provider

class MapBloc extends ChangeNotifier  {
  final mapScreenScaffoldKey = GlobalKey<ScaffoldState>();

  Socket socket;

  // Tag for Logs
  static const TAG = "MapBloc";
  GetIt getIt = GetIt.instance;

  //Current Position and Destination Position and Pickup Point
  LatLng _currentPosition, _destinationPosition, _pickupPosition;
  BusStop _destinationBusstop, _pickupBusstop;

  // Default Camera Zoom
  double currentZoom = 19;

  // Set of all the markers on the map
  final Set<Marker> _markers = Set();

  // Set of all the polyLines/routes on the map
  final Set<Polyline> _polyLines = Set();


  // Pickup Predictions using Places Api, It is the list of Predictions we get from the textchanges the PickupText field in the mainScreen
  List<BusStop> pickupPredictions = [];
  bool pickupPredictionsLoading = false;

  //Same as PickupPredictions but for destination TextField in mainScreen
  List<BusStop> destinationPredictions = [];
  bool destinationPredictionsLoading = false;

  //Same as PickupPredictions but for destination TextField in mainScreen
  List<BusStop> favouritePlaces = [];

  //Map Controller
  GoogleMapController _mapController;


  RideType selectedRideType;
  int currentIndex;
  bool riderFound = false;
  bool choiceRide = false;

  final _indexController = BehaviorSubject<int>();
  Stream<int> get outCurrentIndex => _indexController.stream;



  RideTrackerRepository rideTrackerRepository = new RideTrackerRepository();
  RideRepository rideRepository = new RideRepository();
  final _rideTrackerController =  BehaviorSubject<RideTracker>();
  Stream<RideTracker> get rideTracker => _rideTrackerController.stream;

  final _availableDriverController =  BehaviorSubject<List<RideRequest>>();
  Stream<List<RideRequest>> get availableDrivers => _availableDriverController.stream;

  final _availablePassengerController =  BehaviorSubject<List<RideRequest>>();
  Stream<List<RideRequest>> get availablePassengers => _availablePassengerController.stream;

  final _movingPassengerController =  BehaviorSubject<List<RideRequest>>();
  Stream<List<RideRequest>> get movingPassengers => _movingPassengerController.stream;

  MapRepository mapRepo = new MapRepository();


  final _currentAddressController = BehaviorSubject<String>();
  Function(String) get rideTrackerChanged => _currentAddressController.sink.add;
  Stream<String> get currentAddress => _currentAddressController.stream;



  // FormField Controller for the pickup field
  TextEditingController pickupFormFieldController = TextEditingController();

  // FormField Controller for the destination field
  TextEditingController destinationFormFieldController =
      TextEditingController();


  // Location Object to get current Location
  location.Location _location = location.Location();


  // currentPosition Getter
  LatLng get currentPosition => _currentPosition;

  // currentPosition Getter
  LatLng get destinationPosition => _destinationPosition;

  // currentPosition Getter
  LatLng get pickupPosition => _pickupPosition;

  // currentPosition Getter
  BusStop get pickupBusstop => _pickupBusstop;

  // currentPosition Getter
  BusStop get destinationBusstop => _destinationBusstop;

  // MapRepository Getter
//  MapRepository get mapRepo => _mapRepository;

  // MapController Getter
  GoogleMapController get mapController => _mapController;

  // Markers Getter
  Set<Marker> get markers => _markers;

  // PolyLines Getter
  Set<Polyline> get polyLines => _polyLines;

  get randomZoom => 13.0 + Random().nextInt(4);

  /// Default Constructor
  MapBloc() {
    _getUserLocation();

    //A listener on _location to always get current location and update it.
    _location.onLocationChanged.listen((event) async {
      _currentPosition = LatLng(event.latitude, event.longitude);
      markers.removeWhere((marker) {
        return marker.markerId.value == Constants.currentLocationMarkerId;
      });
      markers.remove(
          Marker(markerId: MarkerId(Constants.currentLocationMarkerId)));
      markers.add(Marker(
          markerId: MarkerId(Constants.currentLocationMarkerId),
          position: _currentPosition,
          rotation: event.heading - 78,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(
            await Utils.getBytesFromAsset(
                "assets/images/current_location.png", 280),
          )));
      notifyListeners();
    });



    // getFavouritePlaces();


    if(socket != null) {
      socket.on(
          "driver_update",
              (status) =>
          {
            fetchNearbyDrivers(UserPosition.fromJson(status))
          });

      socket.on(
          "passenger_update",
              (status) =>
          {
            fetchNearbyPassengers(UserPosition.fromJson(status))
          });
    }

  }

  ///Callback whenever data in Pickup TextField is changed
  //onChanged()
  onPickupTextFieldChanged(String string) async {
    pickupPredictionsLoading = true;
    if (string.isEmpty) {
      pickupPredictions = null;
    } else {
      try {
        destinationPredictions = [];
        await mapRepo.autoCompleteBusstop(string).then((response) {
          pickupPredictions = response;
        });
      } catch (e) {
        print(e);
      }
      pickupPredictionsLoading = false;
      notifyListeners();
    }
  }





  ///Callback whenever data in destination TextField is changed
  ///onChanged()
  onDestinationTextFieldChanged(String string) async {
    destinationPredictionsLoading = true;
    if (string.isEmpty) {
      destinationPredictions = null;
    } else {
      try {
        await mapRepo
            .destinationPoint(string,
                pickupBusstop != null ? pickupBusstop.id.toString() : null)
            .then((response) {
          destinationPredictions = response;
        });
      } catch (e) {
        print(e);
      }
    }
    destinationPredictionsLoading = false;
    notifyListeners();
  }

  ///Getting current Location : Works only one time
  void _getUserLocation() async {
    _location.getLocation().then((data) async {
      _currentPosition = LatLng(data.latitude, data.longitude);

      _pickupPosition = _currentPosition;

      nearestBusstopCoordinate(_currentPosition)
          .then((value) => {pickupPredictions = value});


      _currentAddressController.add(await mapRepo
          .getPlaceNameFromLatLng(LatLng(data.latitude, data.longitude)));

      updatePickupMarker();
      notifyListeners();
    });
  }

  ///Creating a Route
  void createCurrentRoute(String encodedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(Constants.currentRoutePolylineId),
        width: 3,
        geodesic: true,
        points: Utils.convertToLatLng(Utils.decodePoly(encodedPoly)),
        color: backgroundColor));
    notifyListeners();
  }

  ///Adding or updating Destination Marker on the Map
  updateDestinationMarker() async {
    if (destinationPosition == null) return;

    markers.add(Marker(
        markerId: MarkerId(Constants.destinationMarkerId),
        position: destinationPosition,
        draggable: true,
        onDragEnd: onDestinationMarkerDragged,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(
            await Utils.getBytesFromAsset("assets/images/destinationIcon.png", 80))));
    notifyListeners();
  }

  ///Adding or updating Destination Marker on the Map
  updatePickupMarker() async {
    if (pickupPosition == null) return;
    _markers.add(Marker(
        markerId: MarkerId(Constants.pickupMarkerId),
        position: pickupPosition,
        draggable: true,
        onDragEnd: onPickupMarkerDragged,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(
            await Utils.getBytesFromAsset("assets/images/pickupIcon.png", 80))));
    notifyListeners();
  }



  ///on Destination predictions item clicked
  onDestinationPredictionItemClick(BusStop prediction) async {
    destinationFormFieldController.text = prediction.formatted_address;

    _destinationBusstop = prediction;
    _destinationPosition = LatLng(prediction.latitude, prediction.longitude);
    destinationPredictions = null;

    onDestinationPositionChanged();
    notifyListeners();
  }

  ///on Pickup predictions item clicked
  onPickupPredictionItemClick(BusStop prediction) async {
    pickupFormFieldController.text = prediction.formatted_address;

    _pickupBusstop = prediction;
    _pickupPosition = LatLng(prediction.latitude, prediction.longitude);
    pickupPredictions = null;


    onPickupPositionChanged();
    notifyListeners();
  }


  /// listening to camera moving event
  void onCameraMove(CameraPosition position) {
    //ProjectLog.logIt(TAG, "onCameraMove", position.target.toString());
    currentZoom = position.zoom;
    notifyListeners();
  }

  /// when map is created
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    rootBundle.loadString('assets/mapStyle.txt').then((string) {
      _mapController.setMapStyle(string);
    });
    notifyListeners();
  }

  bool checkDestinationOriginForNull() {
    if (pickupPosition == null || destinationPosition == null)
      return false;
    else
      return true;
  }

  void randomMapZoom() {
    mapController
        .animateCamera(CameraUpdate.zoomTo(15.0 + Random().nextInt(5)));
  }

  void onMyLocationFabClicked() {
    // check if ride is ongoing or not, if not that show current position
    // else we will show the camera at the mid point of both locations
    mapController.animateCamera(CameraUpdate.newLatLngZoom(
        currentPosition, 15.0 + Random().nextInt(4)));
    //its overriding the above statement of zoom. beware
    // randomMapZoom();
  }

  Future<void> fetchNearbyDrivers(UserPosition userPosition) async {
    if (userPosition != null && userPosition.isDriver != null &&
        userPosition.isDriver && userPosition.latitude != null &&
        userPosition.longitude != null && !choiceRide) {
      LatLng latLng = new LatLng(userPosition.latitude, userPosition.longitude);
      markers.add(Marker(
          markerId: MarkerId(userPosition.user_id.toString()),
          infoWindow: InfoWindow(title: userPosition.first_name),
          position: latLng,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(
              await Utils.getBytesFromAsset("assets/images/carIcon.png", 80))));
      notifyListeners();
    }
  }

  Future<void> fetchNearbyPassengers(UserPosition userPosition) async {

    if (userPosition != null && userPosition.latitude != null && userPosition.longitude != null && choiceRide) {
      LatLng latLng = new LatLng(userPosition.latitude, userPosition.longitude);
      markers.add(Marker(
          markerId: MarkerId(userPosition.user_id.toString()),
          infoWindow: InfoWindow(title: userPosition.first_name),
          position: latLng,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(await Utils.getBytesFromAsset(
              "assets/images/pickupIcon.png", 80))));
      notifyListeners();
    }
  }

  void onDestinationPositionChanged() {
    updateDestinationMarker();
    mapController.animateCamera(
        CameraUpdate.newLatLngZoom(destinationPosition, randomZoom));
    notifyListeners();
  }

  void onPickupPositionChanged() {
    updatePickupMarker();
    mapController
        .animateCamera(CameraUpdate.newLatLngZoom(pickupPosition, randomZoom));
//    if (destinationPosition != null) sendRouteRequest();
    notifyListeners();
  }

  void onPickupMarkerDragged(LatLng value) async {
    _pickupPosition = value;
    pickupFormFieldController.text =
        await mapRepo.getPlaceNameFromLatLng(value);
    onPickupPositionChanged();
    notifyListeners();
  }

  void onDestinationMarkerDragged(LatLng latLng) async {
    _destinationPosition = latLng;
    destinationFormFieldController.text =
        await mapRepo.getPlaceNameFromLatLng(latLng);
    onDestinationPositionChanged();
    notifyListeners();
  }

  void panelIsOpened() {
//    animateCameraForOD();
    if (checkDestinationOriginForNull()) {
      animateCameraForOD();
    } else {
      //Following statement is creating unnecessary zooms. maybe because panelIsOpened is called on every gesture.
      //randomMapZoom();
    }
  }

  void animateCameraForOD() {
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
              northeast: pickupPosition, southwest: destinationPosition),
          100),
    );
  }

  void panelIsClosed() {
    onMyLocationFabClicked();
  }


  CurrentRideBloc() {
    selectedRideType = RideType.Classic;
  }

  carTypeChanged(int index, reason) {
    currentIndex = index;
    selectedRideType = RideType.values[index];
    _indexController.add(index);
    // notifyListeners();
  }



  setChoiceRide(bool status) {
    choiceRide = status;
    StorageHelper.setBool(StorageKeys.isDriver, status);
    return choiceRide;
  }

  getChoiceRide() {
    return choiceRide;
  }


  Future<RideTracker> createRideTracker(RideTrackerBinder model) async {
    try {
      return await rideTrackerRepository.create(model);
    } catch (ex) {
      if (ex.response.statusCode == 401) {
        throw Exception(ex.response.data['error']);
      } else {
        throw Exception(ex.message);
      }
    }
  }

  Future<RideRequest> rideRequest(BindRideRequest model) async {
    try {
      return await mapRepo.rideRequest(model);
    } catch (ex) {
      throw Exception(ex.message);
    }
  }

  Future<List<BusStop>> nearestBusstopCoordinate(LatLng latLng) async {
    try {
      return await mapRepo.nearestBusstopCoordinate(latLng);
    } catch (ex) {

    }
  }
  Future<void> getAvailableDrivers() async {
    try {
      RideRequestBinder ride = new RideRequestBinder();
      ride.destination_id = destinationBusstop != null ? destinationBusstop.id : null;
      ride.start_id = pickupBusstop != null ? pickupBusstop.id : null;
      ride.carType = "B";
      ride.driver = true;
      List<RideRequest> response = await rideRepository.getAvailableRide(ride);
      _availableDriverController.sink.add(response);
      notifyListeners();
    } catch (ex) {

    }
  }

  void updateAvailableDrivers(){

  }


  Future<void> getAvailablePassengers() async {
    try {
      // _availablePassengerController.value = null;
      RideRequestBinder ride = new RideRequestBinder();
      ride.destination_id = destinationBusstop != null ? destinationBusstop.id : null;
      ride.start_id = pickupBusstop != null ? pickupBusstop.id : null;
      ride.carType = "B";
      ride.driver = false;

      List<RideRequest> response = await rideRepository.getAvailableRide(ride);
      _availablePassengerController.sink.add(response);
      notifyListeners();
    } catch (ex) {

    }
  }

  Future<void> getOnboardPassengers() async {
    try {


      List<RideRequest> response = await rideRepository.getOnboardPassengers();
      _movingPassengerController.sink.add(response);
      notifyListeners();
    } catch (ex) {

    }
  }

  void updateAvailablePassengers(){

  }


  Future<void> getMovingPassengers() async {
    try {

      _movingPassengerController.value = null;

      RideRequestBinder ride = new RideRequestBinder();
      ride.destination_id = destinationBusstop != null ? destinationBusstop.id : null;
      ride.start_id = pickupBusstop != null ? pickupBusstop.id : null;
      ride.carType = "B";
      ride.driver = false;

      List<RideRequest> response = await rideRepository.getAvailableRide(ride);
      _movingPassengerController.sink.add(response);

      /*
      Add a listener that select user to be displayed on the map
       */
      notifyListeners();
    } catch (ex) {

    }
  }

  void updateMovingPassengers(){

  }



  @override
  void dispose() {
    // TODO: implement dispose
  }
}

abstract class BaseBloc {
  void dispose();
}

