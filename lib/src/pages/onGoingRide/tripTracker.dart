import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roadx/src/blocs/MapModel.dart';
import 'package:roadx/src/blocs/RideBookedBloc.dart';
import 'package:roadx/src/blocs/SocketBloc.dart';
import 'package:roadx/src/blocs/UINotifiersBloc.dart';
import 'package:roadx/src/blocs/auth.bloc.dart';
import 'package:roadx/src/helpers/BasicShapeUtils.dart';
import 'package:roadx/src/helpers/Utils.dart';
import 'package:roadx/src/models/Enums/Enums.dart';
import 'package:roadx/src/models/RideTracker.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/pages/onGoingRide/DriverInRoute.dart';
import 'package:roadx/src/pages/onGoingRide/DriverOnWay.dart';
import 'package:roadx/src/pages/onGoingRide/driver_reached_widget.dart';
import 'package:roadx/src/widgets/CustomAppBar.dart';
import 'package:roadx/src/widgets/NoInternetWidget.dart';
import 'package:roadx/src/widgets/drawer.dart';
import 'package:roadx/src/widgets/lifecycle/services/socker_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TripTrackerWidget extends StatefulWidget {
  @override
  createState() => _TripTrackerPage();
}

class _TripTrackerPage extends State<TripTrackerWidget> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  double _panelHeightOpen;
  double _panelHeightClosed = 300.0;

  @override
  void initState() {
    super.initState();
  }

  AuthBloc authBloc;
  SocketBloc socketBlock;
  UINotifiersBloc uiNotifiersModel;
  MapBloc mapModel;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    authBloc = Provider.of<AuthBloc>(context);
    socketBlock = Provider.of<SocketBloc>(context);
    uiNotifiersModel = Provider.of<UINotifiersBloc>(context);
    mapModel = Provider.of<MapBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    return Material(
      child: Scaffold(
          key: _globalKey,
          resizeToAvoidBottomInset: false,
          drawer: SideMenu(scaffoldKey: _globalKey),
          resizeToAvoidBottomPadding: true,
          body: Stack(
            children: <Widget>[
              SlidingUpPanel(
                onPanelSlide: uiNotifiersModel.setOriginDestinationVisibility,
                onPanelOpened: () {
                  uiNotifiersModel.onPanelOpen();
                  mapModel.panelIsOpened();
                  Utils.hideKeyboard(context);
                },
                onPanelClosed: () {
                  uiNotifiersModel.onPanelClosed();
                  mapModel.panelIsClosed();
                  Utils.hideKeyboard(context);
                },
                maxHeight: _panelHeightOpen,
                minHeight: _panelHeightClosed,
                parallaxEnabled: true,
                parallaxOffset: .5,
                color: Colors.white,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    blurRadius: 8.0,
                    color: Color.fromRGBO(193, 231, 208, 0),
                  )
                ],
                controller: uiNotifiersModel.panelController,
                borderRadius: ShapeUtils.borderRadiusGeometry,
                body: GoogleMap(
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
                panelBuilder: (sc) => _panel(sc),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                      visible: uiNotifiersModel.searchingRide ? false : true,
                      child: Opacity(
                          opacity:
                              (uiNotifiersModel.originDestinationVisibility),
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
                                      _globalKey.currentState.openDrawer();
                                    }),
                              ))),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: NoInternetWidget(),
              ),
            ],
          )),
    );
  }

  @override
  Widget _panel(ScrollController sci) {
    return StreamBuilder<UserDetails>(
        stream: authBloc.user,
        builder: (context, snapshot) {
          UserDetails user = snapshot.data;
          return StreamBuilder<RideTracker>(
              stream: socketBlock.rideTracker,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return view(snapshot.data, user);
                else
                  return view(null, user);
              });
        });
  }

  Widget view(RideTracker rideTracker, UserDetails user) {
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
        body: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: getStatus(rideTracker, user),
        ));
  }

  Widget getStatus(RideTracker rideTracker, UserDetails user) {
    if (rideTracker == RideStatus.onWay) {
      return DriverReachedWidget(rideTracker: rideTracker, user : user, mapModel: mapModel);
    }
    // else if (rideTracker == RideStatus.inRoute) {
    //   return DriverInRoute(rideTracker: rideTracker, user: user);
    // }
    else {
      return DriverOnWay(rideTracker: rideTracker, user : user, mapModel:mapModel);
    }
  }
}
