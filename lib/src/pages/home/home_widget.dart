import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:roadx/src/blocs/MapModel.dart';
import 'package:roadx/src/blocs/RideBookedBloc.dart';
import 'package:roadx/src/blocs/UINotifiersBloc.dart';
import 'package:roadx/src/blocs/auth.bloc.dart';
import 'package:roadx/src/helpers/BasicShapeUtils.dart';
import 'package:roadx/src/helpers/Utils.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/models/BusStop.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/pages/login/login_widget.dart';
import 'package:roadx/src/pages/profile/profile_widget.dart';
import 'package:roadx/src/repositories/sources/network/base/endpoints.dart';
import 'package:roadx/src/values/colors.dart';
import 'package:roadx/src/widgets/AnimatedFloatingButton.dart';
import 'package:roadx/src/widgets/CustomAppBar.dart';
import 'package:roadx/src/widgets/HawkFabMenu.dart';
import 'package:roadx/src/widgets/ModelUtil.dart';
import 'package:roadx/src/widgets/NoInternetWidget.dart';
import 'package:roadx/src/widgets/PredictionsLIstPlace.dart';
import 'package:roadx/src/widgets/animated-floatbuttons/animated_floatactionbuttons.dart';
import 'package:roadx/src/widgets/drawer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

/// MainScreen  :  It contains the code of the MAP SCREEN, the Screen just after the Location Permissions.
class HomePage extends StatefulWidget {
  // Material Page Route
  static const route = "/mainScreen";

  // Tag for logging
  static const TAG = "MainScreen";

  bool successfulRegister;
  bool showLogin;

  HomePage({Key key, this.successfulRegister, this.showLogin})
      : super(key: key);

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Animation<double> animation;
  double _fabHeight;
  final double _initFabHeight = 220.0;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  UserDetails userDetails;

  GetIt getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      StorageHelper.setBool(StorageKeys.REDIRECT_CHOOSE_RIDE, false);
      ModelUtil.neverSatisfied(context);
      ModelUtil.successRegistration(context);
    });
    _fabHeight = _initFabHeight;

    userDetails = new UserDetails();
    requestPermission();
  }


  Future<void> requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse,
    ].request();

    //If it doesnt have Permission
    if (!await Permission.camera.status.isGranted || !await Permission.mediaLibrary.status.isGranted || !await Permission.photos.status.isGranted) {
      Navigator.pop(context);
    }
  }

  UINotifiersBloc uiNotifiersModel;
  MapBloc mapModel;
  // RideBookedBloc rideBookedBloc;
  AuthBloc userBloc;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    uiNotifiersModel = Provider.of<UINotifiersBloc>(context);
    mapModel = Provider.of<MapBloc>(context);
    // rideBookedBloc = Provider.of<RideBookedBloc>(context);
    userBloc = Provider.of<AuthBloc>(context);
    userBloc.loadClient();

  }




  @override
  Widget build(BuildContext context) {

    return StreamBuilder<UserDetails>(
        stream: userBloc.user,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userDetails = snapshot.data;
          }
          return view();
        });
  }

  @override
  Widget view() {



    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return Scaffold(
                key: _globalKey,
                drawer: SideMenu(scaffoldKey: _globalKey),
                resizeToAvoidBottomPadding: true,
                body: Stack(
                  children: <Widget>[
                    SlidingUpPanel(
                      onPanelSlide: (double pos) => {
                        uiNotifiersModel.setOriginDestinationVisibility(pos),
                        setState(() {
                          _fabHeight =
                              pos * (_panelHeightOpen - _panelHeightClosed) +
                                  _initFabHeight;
                        })
                      },
                      onPanelOpened: () {
                        uiNotifiersModel.onPanelOpen();
                        mapModel.panelIsOpened();
                      },
                      onPanelClosed: () {
                        uiNotifiersModel.onPanelClosed();
                        mapModel.panelIsClosed();
                      },
                      minHeight: 200,
                      maxHeight: MediaQuery.of(context).size.height,
                      parallaxEnabled: true,
                      parallaxOffset: 0.5,
                      color: Colors.transparent,
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          blurRadius: 8.0,
                          color: Color.fromRGBO(0, 0, 0, 0),
                        )
                      ],
                      controller: uiNotifiersModel.panelController,
                      borderRadius: ShapeUtils.borderRadiusGeometry,
                      body: (mapModel.currentPosition == null)
                          ? Image.asset("assets/images/loading_map.png")
                          : GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  target: mapModel.currentPosition,
                                  zoom: mapModel.currentZoom),
                              onMapCreated: mapModel.onMapCreated,
                              mapType: MapType.normal,
                              rotateGesturesEnabled: false,
                              tiltGesturesEnabled: false,
                              zoomGesturesEnabled: true,
                              markers: mapModel.markers,
                              onCameraMove: mapModel.onCameraMove,
                              polylines: mapModel.polyLines,
                            ),
                      panel: _panel(),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                            visible:
                                uiNotifiersModel.searchingRide ? false : true,
                            child: Opacity(
                                opacity: (uiNotifiersModel
                                    .originDestinationVisibility),
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10, top: 30),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      padding: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/menu_background.png"),
                                              fit: BoxFit.fill)),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.menu,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            _globalKey.currentState
                                                .openDrawer();
                                          }),
                                    ))),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        right: 20.0,
                        bottom: _fabHeight,
                        child: Visibility(
                            visible:
                                uiNotifiersModel.searchingRide ? false : true,
                            child: Opacity(
                              opacity: (uiNotifiersModel
                                  .originDestinationVisibility),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[

                                  AnimatedFloatingButton(
                                      fabButtons: <AnimatedFloatingText>[
                                        float1(),
                                         float2()
                                      ],
                                      colorStartAnimation: backgroundColor,
                                      colorEndAnimation: backgroundColor,
                                      animatedIconData:
                                          mapModel.getChoiceRide()
                                              ? Image.asset(
                                                  "assets/images/fab_driver.png",
                                                  height: 29,
                                                  width: 29,
                                                )
                                              : Image.asset(
                                                  "assets/images/fab_passenger.png",
                                                  height: 29,
                                                  width: 29,
                                                )
                                  ),


                                  SizedBox(
                                    height: 20,
                                  ),
                                  FloatingActionButton(
                                    heroTag: "my_location",
                                    onPressed: mapModel.onMyLocationFabClicked,
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                      "assets/images/fab_location.png",
                                      height: 32,
                                      width: 32,
                                    ),
                                  )
                                ],
                              ),
                            ))),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: NoInternetWidget(),
                    ),
                  ],
                ),
          );

  }

  AnimatedFloatingText float1() {
    return AnimatedFloatingText(
      hasLabel: true,
      labelText: "Passenger",
      currentButton: FloatingActionButton(
        mini: true,
        backgroundColor: !mapModel.getChoiceRide() ? backgroundColor : Colors.white,
        heroTag: "dfdfdfd",
        onPressed: () {
          setState(() {
            mapModel.setChoiceRide(false);
          });
        },
        tooltip: 'First button',
        child: Image.asset("assets/images/fab_passenger.png",
          height: 29,
          width: 29,
        ),
      ),
    );
  }

  Widget float2() {

    return AnimatedFloatingText(
      hasLabel: true,
      labelText: "Driver",
      currentButton: FloatingActionButton(
        backgroundColor: mapModel.getChoiceRide() ? backgroundColor : Colors.white,
        mini: true,
        heroTag: "fab_driver",
        onPressed: () {
          checkCanBeDriver();
        },
        tooltip: 'Second button',
        child: Image.asset("assets/images/fab_driver.png",
          height: 29,
          width: 29,
        ),
      ),
    );
  }

  void checkCanBeDriver() {
          if(userDetails == null){
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new LoginWidget()));
          }else if(userDetails.number_plate == null) {
            Fluttertoast.showToast(
                msg: "Your profile account is still incomplete",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new ProfileWidget()));
          }else {
            setState(() {
              mapModel.setChoiceRide(true);
            });
          }
  }

  Widget _panel() {
    return Scaffold(
        appBar: CustomAppBar(
          height: 250,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Stack(children: <Widget>[
            Visibility(
              visible:
                  (1 - uiNotifiersModel.originDestinationVisibility) < 0.2 ||
                          uiNotifiersModel.searchingRide
                      ? false
                      : true,
              child: Opacity(
                opacity: (1 - uiNotifiersModel.originDestinationVisibility),
                child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      title: Text(
                        "Set Destination",
                        style: new TextStyle(color: Color(0xFFA5AAAE)),
                      ),
                      actions: [
                        InkWell(
                            onTap: () {
                              FocusManager.instance.primaryFocus.unfocus();
                              uiNotifiersModel.getPanelController().close();
                            },
                            child: new Image.asset(
                              'assets/images/cancel_grey.png',
                              width: 30,
                              height: 30,
                            ) // the arrow back icon
                            ),
                      ],
                      elevation: 0,
                    ),
                    body: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, right: 10, left: 10, bottom: 10),
                              child: SizedBox(
                                  height: 105,
                                  child: Image.asset(
                                    "assets/images/location_indicator.png",
                                    fit: BoxFit.fitHeight,
                                  )),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Current Position",
                                    style: new TextStyle(
                                        color: Color(0xFF0100FF), fontSize: 12),
                                  ),
                                  new Container(
//                                      margin: const EdgeInsets.all(15.0),
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xffdddddd))),
                                    child: TextField(
                                      textInputAction: TextInputAction.next,
                                      autofocus: true,
                                      onSubmitted: mapModel.onPickupTextFieldChanged, // move focus to next
                                      cursorColor: Colors.black,
                                      onChanged: mapModel.onPickupTextFieldChanged,
                                      controller:
                                          mapModel.pickupFormFieldController,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 17),
                                        hintText: 'Search your trips',
                                        border: InputBorder.none,
                                        suffix: mapModel.pickupPredictionsLoading ? SizedBox(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 1
                                          ),
                                          height: 10.0,
                                          width: 10.0,
                                        ): null,
                                      ),

                                    ),
                                  ),

                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "Destination",
                                    style: new TextStyle(
                                        color: Color(0xFF0100FF), fontSize: 12),
                                  ),
                                  new Container(
//                                      margin: const EdgeInsets.all(15.0),
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xffdddddd))),
                                      child: TextField(
                                        cursorColor: Colors.black,
                                        textInputAction: TextInputAction.done,
                                        onSubmitted:mapModel.onDestinationTextFieldChanged,
                                        onChanged: mapModel.onDestinationTextFieldChanged,
                                        // FocusScope.of(context).unfocus(),
                                        controller: mapModel
                                            .destinationFormFieldController,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(fontSize: 17),
                                          hintText: "Destination",
                                          border: InputBorder.none,
                                          suffix: mapModel.destinationPredictionsLoading ? SizedBox(
                                            child: CircularProgressIndicator(
                                                strokeWidth: 1
                                            ),
                                            height: 10.0,
                                            width: 10.0,
                                          ): null,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
            Visibility(
              visible: (uiNotifiersModel.originDestinationVisibility) < 0.2 ||
                      uiNotifiersModel.searchingRide
                  ? false
                  : true,
              child: Opacity(
                  opacity: (uiNotifiersModel.originDestinationVisibility),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 72,
                            height: 4,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0))),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        userDetails != null && userDetails.id != null ?  greeting()+", "+ Utils.capitalLetter(userDetails.first_name) : greeting(),
                        style: TextStyle(
                          color: Color(0xFF434343),
                          fontWeight: FontWeight.normal,
                          fontSize: 10.0,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "Where are you going?",
                        style: TextStyle(
                          color: Color(0xFF434343),
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      TextField(
                        enableInteractiveSelection: false,
                        // will disable paste operation
                        focusNode: new FocusNode(),
                        onTap: () => {
                          FocusManager.instance.primaryFocus.unfocus(),
                          uiNotifiersModel.getPanelController().open(),
                        },
                        showCursor: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1.0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1.0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                          ),
                          labelText: "Search for a destination",
                          suffixIcon: Icon(
                            Icons.search,
                            color: Color(0xFFCACACA),
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ],
                  )),
            ),
          ]),
        ),
        body: PredictionsLIstPlace(
          pickupPredictions: mapModel.pickupPredictions,
          pickupPredictionTap: mapModel.onPickupPredictionItemClick,
          destinationPredictions: mapModel.destinationPredictions,
          destinationPredictionTap: mapModel.onDestinationPredictionItemClick,
          favourites: mapModel.favouritePlaces,
          favouriteTap: mapModel.onDestinationPredictionItemClick,
          selectedPickupPredictions: (BusStop keyword) =>{
            FocusScope.of(context).nextFocus()
          },
        ));
  }

  Widget driverPanel() {
    return Scaffold(
        appBar: CustomAppBar(
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 72,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        ),
        body: Container());
  }
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

}
