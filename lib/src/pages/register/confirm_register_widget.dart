import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roadx/src/blocs/MapModel.dart';
import 'package:roadx/src/blocs/UINotifiersBloc.dart';
import 'package:roadx/src/blocs/validateRegister.bloc.dart';
import 'package:roadx/src/helpers/BasicShapeUtils.dart';
import 'package:roadx/src/widgets/CustomAppBar.dart';
import 'package:roadx/src/widgets/NoInternetWidget.dart';
import 'package:roadx/src/widgets/button.dart';
import 'package:roadx/src/widgets/drawer.dart';
import 'package:roadx/src/widgets/edit_text.dart';
import 'package:roadx/src/widgets/loading.dart';
import 'package:roadx/src/widgets/verification_code_input.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ConfirmRegisterWidget extends StatefulWidget {

  @override
   createState() => _ConfirmRegisterWidgetPage();
}

class _ConfirmRegisterWidgetPage extends State<ConfirmRegisterWidget> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  double _panelHeightOpen;
  double _panelHeightClosed = 300.0;
  AnimationController stateController;




  ValidateRegisterBloc bloc;
  MapBloc mapModel;
  UINotifiersBloc uiNotifiersModel;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    bloc = Provider.of<ValidateRegisterBloc>(context);
    mapModel = Provider.of<MapBloc>(context);
    uiNotifiersModel = Provider.of<UINotifiersBloc>(context);
  }


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery
        .of(context)
        .size
        .height * .80;
    return Loading(
        message: "Loading message",
        status: bloc.loading,
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
                },
                onPanelClosed: () {
                  uiNotifiersModel.onPanelClosed();
                  mapModel.panelIsClosed();
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
                                Icons.menu,
                                size: 30,
                              ),
                              onPressed: () {
                                _globalKey.currentState.openDrawer();
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
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                child:  new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 12.0,
                        ),
                        Text("Verify Your Mobile",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF434343))),
                        SizedBox(
                          height: 5.0,
                        ),


                        EditText(
                          labelText: "OTP",
                          onChange: bloc.codeChanged,
                          value: bloc.code,
                        ),

                        SizedBox(
                          height: 10.0,
                        ),

                        StreamBuilder<bool>(
                          stream: bloc.submitCheck,
                          builder: (context, snapshot) =>
                              CustomButton(
                                onPress: snapshot.hasData
                                    ? () => bloc.submit(context)
                                    : null,
                                label: "Proceed",
                              ),
                        ),
                      ],
                    ))));
  }

}
