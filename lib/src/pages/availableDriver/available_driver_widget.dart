import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roadx/src/blocs/MapModel.dart';
import 'package:roadx/src/blocs/RideBookedBloc.dart';
import 'package:roadx/src/blocs/UINotifiersBloc.dart';
import 'package:roadx/src/helpers/BasicShapeUtils.dart';
import 'package:roadx/src/helpers/Utils.dart';
import 'package:roadx/src/models/RideRequest.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/models/socket/TrackerAllPassengers.dart';
import 'package:roadx/src/repositories/ride.repository.dart';
import 'package:roadx/src/widgets/CustomAppBar.dart';
import 'package:roadx/src/widgets/GenericWidget.dart';
import 'package:roadx/src/widgets/NoInternetWidget.dart';
import 'package:roadx/src/widgets/drawer.dart';
import 'package:roadx/src/widgets/lifecycle/services/socker_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:toggle_switch/toggle_switch.dart';

class AvailableDriverWidget extends StatefulWidget {
  @override
  createState() => _AvailableDriverPagePage();
}

class _AvailableDriverPagePage extends State<AvailableDriverWidget> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;
  RideRepository rideRepository = RideRepository();

  UINotifiersBloc uiNotifiersModel;
  MapBloc mapModel;
  // RideBookedBloc rideBookedBloc;
  int isAvailable = 0;
  int count_onboard_passenger = 0;
  GetIt getIt = GetIt.instance;


  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    uiNotifiersModel = Provider.of<UINotifiersBloc>(context);
    mapModel = Provider.of<MapBloc>(context);
    // rideBookedBloc = Provider.of<RideBookedBloc>(context);

    mapModel.getAvailablePassengers();
    mapModel.getOnboardPassengers();

    Utils.hideKeyboard(context);
  }

  @override
  void initState() {
    super.initState();
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

  Widget _panel(ScrollController sc) {
    return Scaffold(
        appBar: CustomAppBar(
          height: 100,
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
                height: 12.0,
              ),
              new Container(
                  margin: new EdgeInsets.only(bottom: 10.0),
                  child: ToggleSwitch(
                      minWidth: 150.0,
                      cornerRadius: 30,
                      initialLabelIndex: isAvailable,
                      activeBgColor: Color(0xFF33CC66),
                      activeFgColor: Colors.white,
                      inactiveBgColor: Color(0xFFEFEFEF),
                      inactiveFgColor: Color(0xFFB4B7BB),
                      labels: ['Not Available', ' Available'],
                      onToggle: onDriverStatus)),
            ],
          ),
        ),
        body: _buildSlivers(sc));
  }

  Widget _buildSlivers(ScrollController sc) {
    return CustomScrollView(
      controller: sc,
      slivers: <Widget>[
        StreamBuilder(
            stream: mapModel.movingPassengers,
            builder: (ctx, AsyncSnapshot<List<RideRequest>> snapshot) {
              return snapshot.hasData
                  ? SliverAppBar(
                      backgroundColor: Colors.white,
                      expandedHeight: 50,
                      automaticallyImplyLeading: false,
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                flex: 8,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "${snapshot.hasData ? snapshot.data.length : 0} ${snapshot.hasData ? 'Passengers' : 'Passenger'} on Board",
                                        style: TextStyle(
                                          color: Color(0xff434343),
                                          fontSize: 18,
                                          fontFamily: "Gilroy-Bold",
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ])),
                            Expanded(
                                flex: 2,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                          onTap: () => {},
                                          child: new Image.asset(
                                            "assets/images/show_hide.png",
                                            width: 19.18,
                                            height: 19.18,
                                          )),
                                    ]))
                          ]),
                    )
                  : SliverToBoxAdapter(
                      child: Container(),
                    );
            }),

        StreamBuilder(
            stream: mapModel.movingPassengers,
            builder: (context, snapshot) => SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) => GenericWidget.getOnboardPassenger(
                      context, snapshot.data[index]),
                  childCount: snapshot.hasData ? 1 : 0,
                ))),
        SliverAppBar(
          backgroundColor: Colors.white,
          expandedHeight: 50,
          automaticallyImplyLeading: false,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    flex: 8,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Available Passengers",
                            style: TextStyle(
                              color: Color(0xff434343),
                              fontSize: 18,
                              fontFamily: "Gilroy-Bold",
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ])),
                Expanded(
                    flex: 2,
                    child: StreamBuilder(
                        stream: mapModel.availablePassengers,
                        builder: (context,
                            AsyncSnapshot<List<RideRequest>> snapshot) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: 41.90,
                                  height: 41.90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff33cc66),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${snapshot.hasData ? snapshot.data.length : 0}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ]);
                        }))
              ]),
        ),
        StreamBuilder(
            stream: mapModel.availablePassengers,
            builder: (context, snapshot) => SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) => GenericWidget.getAvailablePassebger(
                      context, snapshot.data[index]),
                  childCount: snapshot.hasData ? 1 : 0,
                ))),
      ],
    );
  }

  onDriverStatus(index) {
    FocusManager.instance.primaryFocus.unfocus();
    isAvailable = index;
    if (index == 0) {
      _panelHeightClosed = 95.00;
      uiNotifiersModel.getPanelController().close();
    } else {
      _panelHeightClosed = _panelHeightOpen;
      uiNotifiersModel.getPanelController().open();
    }
  }
}
