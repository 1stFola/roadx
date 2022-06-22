import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roadx/src/blocs/MapModel.dart';
import 'package:roadx/src/blocs/UINotifiersBloc.dart';
import 'package:roadx/src/blocs/auth.bloc.dart';
import 'package:roadx/src/helpers/BasicShapeUtils.dart';
import 'package:roadx/src/helpers/Utils.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/models/binder/BindRideRequest.dart';
import 'package:roadx/src/pages/availablePassenger/available_passenger_widget.dart';
import 'package:roadx/src/values/colors.dart';
import 'package:roadx/src/values/constants.dart';
import 'package:roadx/src/widgets/CardSelectionCard.dart';
import 'package:roadx/src/widgets/CustomAppBar.dart';
import 'package:roadx/src/widgets/ModelUtil.dart';
import 'package:roadx/src/widgets/NoInternetWidget.dart';
import 'package:roadx/src/widgets/drawer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class ChooseRideWidget extends StatefulWidget {
  @override
  createState() => _ChooseRideWidgetState();
}

class _ChooseRideWidgetState extends State<ChooseRideWidget> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  double _panelHeightOpen;
  double _panelHeightClosed = 250.0;



  @override
  void initState() {
    super.initState();
    Timer.run(() {
      ModelUtil.successRegistration(context);
    });
  }

  MapBloc mapModel;
  AuthBloc auth;
  UINotifiersBloc uiNotifiersModel;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    uiNotifiersModel = Provider.of<UINotifiersBloc>(context);
    mapModel = Provider.of<MapBloc>(context);
    auth = Provider.of<AuthBloc>(context);
    Utils.hideKeyboard(context);
  }


  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .70;
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
                    Padding(
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
                                      Icons.arrow_back,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              )),
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
    mapModel.carTypeChanged(0, null);
    CarouselController buttonCarouselController = CarouselController();

    return StreamBuilder<UserDetails>(
        stream: auth.user,
        builder: (context, snapshot) {
          UserDetails userDetails = snapshot.data;
          return StreamBuilder(
              stream: mapModel.outCurrentIndex,
              //here you call the flux of data(stream)
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Scaffold(
                  backgroundColor: Colors.white,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                  body: ListView(
                    controller: sc,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                            left: 16.0, right: 16, bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 25, right: 10, left: 10, bottom: 10),
                              child: SizedBox(
                                  height: 75,
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
                                    style: TextStyle(
                                        fontSize: 10, color: backgroundColor),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "${mapModel.pickupBusstop != null && mapModel.pickupBusstop.formatted_address != null ?  mapModel.pickupBusstop.formatted_address : "--"}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF434343),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  Text(
                                    "Destination",
                                    style: TextStyle(
                                        fontSize: 10, color: backgroundColor),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "${mapModel.destinationBusstop != null && mapModel.destinationBusstop.formatted_address != null ?  mapModel.destinationBusstop.formatted_address : "--"}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF434343),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Choose vehicle type",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Stack(children: [
                        CarouselSlider(
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            initialPage: 0,
                            scrollDirection: Axis.horizontal,
                            onPageChanged:
                            mapModel.carTypeChanged,
                          ),
                          items: Constants.typesOfCar.map((i) {
                            int index = Constants.typesOfCar.indexOf(i);
                            return Builder(
                              builder: (BuildContext context) {
                                return InkWell(
                                  onTap: () async {
                                    BindRideRequest ride =
                                        new BindRideRequest();
                                    ride.journey_id = mapModel.destinationBusstop != null ? mapModel.destinationBusstop.journey_id : null;
                                    ride.destination_id = mapModel.destinationBusstop != null ? mapModel.destinationBusstop.id : null;
                                    ride.start_id = mapModel.pickupBusstop != null ? mapModel.pickupBusstop.id : null;
                                    ride.carType = i != null ? i.type : null;
                                    ride.driver = false;
                                    await mapModel
                                        .rideRequest(ride)
                                        .then((value) => {

                                        Navigator.push(context, new MaterialPageRoute(builder: (context) => new AvailablePassengerWidget(ridePassendRequest: value)))


                                            })
                                        .catchError((onError) => {
                                              Fluttertoast.showToast(
                                                  msg: onError.toString(),
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0)
                                            });
                                  },
                                  child: CarSelectionCard(
                                      carTypeMenu: i,
                                      color: snapshot.data == index
                                          ? Color(0xFF2DBB54)
                                          : Color(0xFFD6D6D6)),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        Positioned.fill(
                            child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              getIndicatorWidget(
                                  false, buttonCarouselController),
                              // back arrow icon.
                              getIndicatorWidget(
                                  true, buttonCarouselController),
                              // forward arrow icon.
                            ],
                          ),
                        )),
                      ]),
                    ],
                  ),
                );
              });
        });
  }

  Widget getIndicatorWidget(
      bool isForward, CarouselController buttonCarouselController) {
    if (!isForward) {
      return InkWell(
        onTap: () => buttonCarouselController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.linear),
        child: Image.asset(
          "assets/images/previous_carousel.png",
          fit: BoxFit.fitWidth,
          height: 48,
        ),
      );
    } else {
      return InkWell(
        onTap: () => buttonCarouselController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.linear),
        child: Image.asset(
          "assets/images/next_carousel.png",
          fit: BoxFit.fitWidth,
          height: 48,
        ),
      );
    }
  }
}
