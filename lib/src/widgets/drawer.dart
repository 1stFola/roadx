import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:roadx/src/blocs/auth.bloc.dart';
import 'package:roadx/src/helpers/Utils.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/pages/home/home_widget.dart';
import 'package:roadx/src/pages/login/login_widget.dart';
import 'package:roadx/src/pages/profile/profile_widget.dart';
import 'package:roadx/src/pages/rideHistory/ride_history_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roadx/src/values/colors.dart' as colors;

typedef onListItemTap = void Function(GlobalKey _scaffoldKey);

class SideMenu extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  SideMenu({
    Key key,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  // GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    authBloc = Provider.of<AuthBloc>(context);
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserDetails>(
        stream: authBloc.user,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return view(context, snapshot.data);
          else
            return view(context, null);
        });
  }

  @override
  Widget view(BuildContext context, UserDetails userDetails) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      if (widget.scaffoldKey.currentState.isDrawerOpen) {
                        widget.scaffoldKey.currentState.openEndDrawer();
                      }
                    },
                    child: new Image.asset(
                      "assets/images/cancel_sidebar_white.png",
                      width: 19.18,
                      height: 19.18,
                    )),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: userDetails != null
                          ? () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new ProfileWidget()));
                      }
                          : null,
                      child: Container(
                        child: new GestureDetector(
                          child: new Center(
                            child:
                                userDetails != null && userDetails.image != null
                                    ? new CircleAvatar(
                                        radius: 40.0,
                                        backgroundColor: Colors.white,
                                        backgroundImage: Utils.getImage(userDetails.image),
                                      )
                                    : new CircleAvatar(
                                        radius: 40.0,
                                        backgroundColor: Colors.white,
                                        backgroundImage: new AssetImage(
                                            "assets/images/avatar.jpg"),
                                      ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    InkWell(
                        onTap: userDetails != null
                            ? () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new ProfileWidget()));
                        }
                            : null,
                        child: new Center(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                '${userDetails != null ? Utils.capitalLetter(userDetails.first_name) + " " + Utils.capitalLetter(userDetails.last_name) : "Guest"}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.clip,
                                softWrap: false,
                              ),
                            ),
                            getUserWidget(userDetails)
                          ],
                        ))),
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
              color: colors.backgroundColor,
            ),
          ),
          ListTile(
            title: Text(
              'Home',
              style: TextStyle(
                color: Color(0xFF908888),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new HomePage()));
            },
          ),

          ListTile(
            title: Text(
              'Profile',
              style: TextStyle(
                color: Color(0xFF908888),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: userDetails != null
                ? () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new ProfileWidget()));
                  }
                : null,
          ),
          // loadDriverSideBar(),
          ListTile(
            title: Text(
              'Your Trips',
              style: TextStyle(
                color: Color(0xFF908888),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: userDetails != null
                ? () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new RideHistoryWidget()));
                  }
                : null,
          ),
          ListTile(
            title: Text(
              'Help',
              style: TextStyle(
                color: Color(0xFF908888),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Payments',
              style: TextStyle(
                color: Color(0xFF908888),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: userDetails != null ? () {} : null,
          ),
          ListTile(
            title: Text(
              'Notification',
              style: TextStyle(
                color: Color(0xFF908888),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              'Settings',
              style: TextStyle(
                color: Color(0xFF908888),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: userDetails != null ? () {} : null,
          ),
          ListTile(
            title: Text(
              userDetails != null ? 'Logout' : 'Login',
              style: TextStyle(
                color: Color(0xFF908888),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () {
              getLogoutAction(userDetails);
            },
          ),
        ],
      ),
    );
  }
/*
  Widget loadDriverSideBar() {
    if (authBloc.getChoiceRide()) {
      return ListTile(
          title: Text(
            'Available Pasengers',
            style: TextStyle(
              color: Color(0xFF908888),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new AvailableDriverWidget()));
          });
    }
    return Container();
  }
*/
  Widget getUserWidget(UserDetails userDetails) {
    if (userDetails != null)
      return RatingBar.readOnly(
        initialRating: userDetails.rate != null ? userDetails.rate : 0,
        isHalfAllowed: true,
        halfFilledIcon: Icons.star_half,
        filledIcon: Icons.star,
        emptyIcon: Icons.star_border,
        filledColor: Colors.white,
        size: 20,
      );
    else
      return Container();
  }

  void getLogoutAction(UserDetails userDetails) {
    if (userDetails != null) {
      authBloc.logout();
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new HomePage()));
    } else {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new LoginWidget()));
    }
  }
}
