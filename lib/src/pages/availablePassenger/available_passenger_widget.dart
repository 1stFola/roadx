import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:roadx/src/blocs/MapModel.dart';
import 'package:roadx/src/blocs/RideBookedBloc.dart';
import 'package:roadx/src/blocs/UINotifiersBloc.dart';
import 'package:roadx/src/blocs/auth.bloc.dart';
import 'package:roadx/src/helpers/BasicShapeUtils.dart';
import 'package:roadx/src/helpers/Utils.dart';
import 'package:roadx/src/models/RideRequest.dart';
import 'package:roadx/src/models/RideTracker.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/models/binder/RideRequestBinder.dart';
import 'package:roadx/src/models/binder/RideTrackerBinder.dart';
import 'package:roadx/src/pages/EmptyScreen/EmptyContent.dart';
import 'package:roadx/src/pages/onGoingRide/tripTracker.dart';
import 'package:roadx/src/repositories/ride.repository.dart';
import 'package:roadx/src/repositories/rideTracker.repository.dart';
import 'package:roadx/src/widgets/CustomAppBar.dart';
import 'package:roadx/src/widgets/NoInternetWidget.dart';
import 'package:roadx/src/widgets/drawer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stream_loader/stream_loader.dart';
import 'package:built_collection/built_collection.dart';

class AvailablePassengerWidget extends StatefulWidget {

  final RideRequest ridePassendRequest;

  const AvailablePassengerWidget({
    Key key,
    this.ridePassendRequest,
  }) : super(key: key);

  @override
  createState() => _AvailablePassengerPage();
}

class _AvailablePassengerPage extends State<AvailablePassengerWidget> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  List<RideRequest> rideTrackers = new List();
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;
  RideRepository rideRepository = RideRepository();
  RideTrackerRepository rideTrackerRepository = RideTrackerRepository();

  UINotifiersBloc uiNotifiersModel;
  MapBloc mapModel;
  // RideBookedBloc rideBookedBloc;
  AuthBloc authBloc;
  RideRequest ridePassendRequest;

  @override
  void initState() {
    super.initState();

    if(widget != null){
      ridePassendRequest = widget.ridePassendRequest;
    }

  }


  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    uiNotifiersModel = Provider.of<UINotifiersBloc>(context);
    mapModel = Provider.of<MapBloc>(context);
    // rideBookedBloc = Provider.of<RideBookedBloc>(context);
    authBloc = Provider.of<AuthBloc>(context);
    mapModel.getAvailableDrivers();

    Utils.hideKeyboard(context);
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

      return Material(
        child: Scaffold(
            key: _globalKey,
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

  Widget _panel(ScrollController sc) {
    return StreamBuilder(
        stream: mapModel.availableDrivers,
        builder: (context, AsyncSnapshot<List<RideRequest>> snapshot) {
          return Scaffold(
              appBar: CustomAppBar(
                  height: 150,
                  child: Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        title: Text(
                          "${snapshot != null && snapshot.data != null && snapshot.data.length > 0 ? snapshot.data.length : 0} Drivers on Route",
                          style: TextStyle(
                            color: Color(0xff434343),
                            fontSize: 18,
                            fontFamily: "Gilroy-SemiBold",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        leading: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: new Image.asset(
                              'assets/images/back.png',
                              width: 30,
                              height: 30,
                            ) // the arrow back icon
                            ),
                        elevation: 0,
                      ),
                      body: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Requested Drivers",
                              style: TextStyle(
                                color: Color(0xff4f4e72),
                                fontSize: 14,
                                fontFamily: "Gilroy-Regular",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(flex: 2, child: getSelectedWidgets()),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: 41.90,
                                      height: 41.90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: rideTrackers != null &&
                                                rideTrackers.length != null &&
                                                rideTrackers.length > 0
                                            ? Color(0xff33CC66)
                                            : Color(0xffE7E8E9),
                                      ),
                                      child: rideTrackers != null &&
                                              rideTrackers.length != null &&
                                              rideTrackers.length > 0
                                          ? Center(
                                              child: Text(
                                                rideTrackers != null &&
                                                        rideTrackers.length !=
                                                            null
                                                    ? rideTrackers.length
                                                        .toString()
                                                    : "0",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                          : new Container(),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ))),
              //body: getAvailableList(sc, state, bloc, userDetails),
              body: loadContent(snapshot));
        });
  }

  Widget loadContent(AsyncSnapshot<List<RideRequest>> snapshot) {
    if (snapshot.connectionState == ConnectionState.active &&
        snapshot.data != null &&
        snapshot.data.length > 0) {
      return new StaggeredGridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(2.0),
        children: snapshot.data.map<Widget>((comment) {
          return content(comment);
        }).toList(),

        staggeredTiles: snapshot.data
            .map<StaggeredTile>((_) => StaggeredTile.fit(2))
            .toList(),
        mainAxisSpacing: 3.0,
        crossAxisSpacing: 4.0, // add some space
      );
    } else if (snapshot.connectionState == ConnectionState.none) {
      return EmptyContent(message: "passenger is empty");
    } else if (snapshot.connectionState == ConnectionState.active &&
        !snapshot.hasData) {
      return EmptyContent(message: "passenger is empty");
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget content(RideRequest rideRequest) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 199,
            height: 144,
            child: Stack(
              children: [
                Container(
                    width: 199,
                    height: 144,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffc4c4c4),
                    ),
                    child: new Image(
                            width: 199,
                            height: 199,
                            image: Utils.getImage(rideRequest != null && rideRequest.user != null ? rideRequest.user.image : null),
                          )
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                      width: 25,
                      height: 25,
                      child: rideRequest != null && rideRequest.user != null && rideRequest.user.id != null &&
                              isDriverSelected(rideRequest.id)
                          ? new Image(
                              image: new AssetImage(
                                  "assets/images/check_driver.png"),
                            )
                          : new Container()),
                )
              ],
            ),
          ),
          SizedBox(height: 3.69),
          Text(
            "${rideRequest != null && rideRequest.user != null && rideRequest.user.first_name != null ? rideRequest.user.first_name : "--"}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff434343),
              fontSize: 18,
              fontFamily: "Gilroy-Regular",
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 3.69),
          RatingBar.readOnly(
            initialRating: rideRequest != null && rideRequest.user != null && rideRequest.user.rate != null
                ? rideRequest.user.rate
                : 0,
            isHalfAllowed: true,
            halfFilledIcon: Icons.star_half,
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
            filledColor: Colors.white,
            size: 15,
          ),
          SizedBox(height: 3.69),
          Text(
            "15 mins away",
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black,
              fontSize: 9,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 3.69),
          InkWell(
            onTap: () async {
              if (!isDriverSelected(rideRequest.id)) {
                RideTrackerBinder ride = RideTrackerBinder();
                ride.passenger_request_id = ridePassendRequest.id;
                ride.driver_request_id = rideRequest.id;
                await rideTrackerRepository.create(ride);
                rideTrackers.add(rideRequest);
              } else {
                rideTrackers.removeWhere((item) => item.id == rideRequest.id);
                await rideTrackerRepository.delete(ridePassendRequest.id, rideRequest.id);
              }

              setState(() {});
            },
            child: Container(
              width: 172,
              height: 27,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: !isDriverSelected(rideRequest.id)
                    ? Color(0xff0000ff)
                    : Color(0xff33CC66),
              ),
              child: Center(
                child: !isDriverSelected(rideRequest.id)
                    ? Text(
                        "Request Ride",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: "Gilroy",
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Text(
                        "Cancel Ride",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: "Gilroy",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isDriverSelected(int rideRequest_id) {
    if (rideTrackers != null) {
      for (var i = 0; i < rideTrackers.length; i++) {
        if (rideTrackers[i] != null && rideTrackers[i].id == rideRequest_id) {
          return true;
        }
      }
    }
    return false;
  }

  RideRequest getDriver(int rideRequest_id) {
    if (rideTrackers != null) {
      for (var i = 0; i < rideTrackers.length; i++) {
        if (rideTrackers[i] != null && rideTrackers[i].id == rideRequest_id) {
          return rideTrackers[i];
        }
      }
    }
  }

  Widget getSelectedWidgets() {
    int total_length = 4;
    int selected_length = rideTrackers != null ? rideTrackers.length : 0;
    int reminder = total_length - selected_length;

    List<Widget> list = new List<Widget>();

    for (var i = 0; i < selected_length; i++) {
      list.add(SizedBox(width: 16.46));
      list.add(new InkWell(
          onTap: () {},
          child: rideTrackers[i] != null && rideTrackers[i].user  != null
              ? new CircleAvatar(
                  radius: 17.50,
                  backgroundColor: Colors.white,
                  backgroundImage: Utils.getImage(rideTrackers[i].user.image),
                )
              : new Image(
                  width: 35.00,
                  height: 35.00,
                  image: new AssetImage("assets/images/add_passenger.png"),
                )));
    }

    for (var i = 0; i < reminder; i++) {
      list.add(SizedBox(width: 16.46));
      list.add(new InkWell(
          onTap: () {},
          child: new Image.asset(
            'assets/images/add_passenger.png',
            width: 35.00,
            height: 35.00,
          ) // the arrow back icon
          ));
    }

    return new Row(children: list);
  }

/*

  void handleMessage(LoaderMessage message, BuildContext context) {
    message.fold(
        onFetchFailure: (error, stackTrace) => {
              Fluttertoast.showToast(
                  msg: 'Fetch error',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0)
            },
        onFetchSuccess: (_) {},
        onRefreshSuccess: (data) => {
              Fluttertoast.showToast(
                  msg: 'Refresh success',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0)
            },
        onRefreshFailure: (error, stackTrace) => {
              Fluttertoast.showToast(
                  msg: 'Refresh error',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0)
            });
  }


   */
}
