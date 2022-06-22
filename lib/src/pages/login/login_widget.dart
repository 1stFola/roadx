import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roadx/src/blocs/MapModel.dart';
import 'package:roadx/src/blocs/UINotifiersBloc.dart';
import 'package:roadx/src/blocs/auth.bloc.dart';
import 'package:roadx/src/helpers/BasicShapeUtils.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/models/binder/AuthenticationRequest.dart';
import 'package:roadx/src/pages/home/home_widget.dart';
import 'package:roadx/src/pages/register/register_widget.dart';
import 'package:roadx/src/widgets/CustomAppBar.dart';
import 'package:roadx/src/widgets/NoInternetWidget.dart';
import 'package:roadx/src/widgets/button.dart';
import 'package:roadx/src/widgets/drawer.dart';
import 'package:roadx/src/widgets/edit_text.dart';
import 'package:roadx/src/widgets/loading.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:social_login_3/social_login_3.dart';

class LoginWidget extends StatefulWidget {
  @override
  createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginWidget> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  AnimationController stateController;
  double _panelHeightOpen;
  double _panelHeightClosed = 300.0;
  bool isLoginingFacebook = false;
  bool isLoginingGoogle = false;

  final SocialLogin socialLogin = SocialLogin();

  static const FACEBOOK_APP_ID = "2249712475303378";
  static const GOOGLE_WEB_CLIENT_ID =
      "439602412049-gb519jk7cp06i3i3u4svjkl92f9j8t4k.apps.googleusercontent.com";
  static const TWITTER_CONSUMER_KEY = "LfNAorWdEOHjjz3ugRd3v3Fyu";
  static const TWITTER_CONSUMER_SECRET =
      "fomJMRxC1XzqLYTaFLqEcknLqfuJBG6naIS1BL3Umma4t4I6et";

  AuthBloc bloc;
  MapBloc mapModel;
  UINotifiersBloc uiNotifiersModel;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    bloc = Provider.of<AuthBloc>(context);
    mapModel = Provider.of<MapBloc>(context);
    uiNotifiersModel = Provider.of<UINotifiersBloc>(context);

    // await StorageHelper.get(StorageKeys.token).then((value) => {
    //       if (value != "")
    //         {
    //           Navigator.push(context,
    //               new MaterialPageRoute(builder: (context) => new HomePage()))
    //         }
    //     });
  }


  @override
  void initState() {
    super.initState();

    socialLogin.setConfig(SocialConfig(
      facebookAppId: FACEBOOK_APP_ID,
      googleWebClientId: GOOGLE_WEB_CLIENT_ID,
      twitterConsumer: TWITTER_CONSUMER_KEY,
      twitterSecret: TWITTER_CONSUMER_SECRET,
    ));

    if(isLoginingFacebook) {
      socialLogin.getCurrentFacebookUser().then((user) {
        var userData = AuthenticationRequest(
            email: user.email,
            first_name: "",
            last_name: user.name,
            image: user.pictureUrl,
            social_token: user.token.toString().trim());

        bloc.socialNetworkLogin(userData, context);
      });
    }

    if(isLoginingGoogle) {
      socialLogin.getCurrentGoogleUser().then((user) {
        bloc.socialNetworkLogin(
            AuthenticationRequest(
                email: user.email,
                first_name: "",
                last_name: user.name,
                image: user.pictureUrl,
                social_token: user.idToken.toString().trim()),
            context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    return Material(
      child: Scaffold(
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
    return Loading(
        message: "Loading message",
        status: bloc.loading,
        child: Scaffold(
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
            color: Colors.white,
            padding: EdgeInsets.only(left: 40, right: 40),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text("Login",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF434343))),
                SizedBox(
                  height: 10.0,
                ),
                EditText(
                  labelText: "Email Address",
                  onChange: bloc.emailChanged,
                  value: bloc.email,
                ),
                SizedBox(
                  height: 3.0,
                ),
                EditText(
                    labelText: "Password",
                    onChange: bloc.passwordChanged,
                    value: bloc.password,
                    password: true,
                    keyboardType: TextInputType.visiblePassword
                ),
                SizedBox(
                  height: 10.0,
                ),
                StreamBuilder<bool>(
                  stream: bloc.submitCheck,
                  builder: (context, snapshot) => CustomButton(
                    onPress:
                        snapshot.hasData ? () => bloc.submit(context) : null,
                    label: "Login",
                  ),
                ),
                SizedBox(
                  height: 17.0,
                ),
                Center(
                  child: Text("Or sign with social",
                      style:
                          TextStyle(fontSize: 12.0, color: Color(0xFFA5AAAE))),
                ),
                SizedBox(
                  height: 17.0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () async {
                            this.isLoginingGoogle = true;
                            await socialLogin.logInGoogle();
                          },
                          child: new Container(
                              child: new Image(
                            height: 43.0,
                            width: 136.0,
                            image: new AssetImage("assets/images/google.png"),
                          )),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () async {
                            try {
                              this.isLoginingFacebook = true;
                              await socialLogin.logInFacebookWithPermissions(
                                  FacebookPermissions.DEFAULT);
                              setState(() {});
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: new Container(
                              child: new Image(
                            height: 43.0,
                            width: 136.0,
                            image: new AssetImage("assets/images/facebook.png"),
                          )),
                        ),
                      )
                    ]),
                SizedBox(
                  height: 10.0,
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new RegisterWidget()));
                    },
                    child: Container(
                      height: 43,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Color(0xff0000ff),
                          width: 1,
                        ),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 9,
                      ),
                      child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Color(0xff0000ff),
                            fontSize: 18,
                            fontFamily: "Gilroy-Bold",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )),
              ],
            )))));
  }
}
