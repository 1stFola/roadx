import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:roadx/src/blocs/SocketBloc.dart';
import 'package:roadx/src/blocs/base/bloc_provider.dart';
import 'package:roadx/src/models/RideTracker.dart';
import 'package:roadx/src/pages/home/GlobalApp.dart';
import 'package:roadx/src/pages/home/home_widget.dart';
import 'package:roadx/src/pages/location/LocationPermissionScreen.dart';
import 'package:roadx/src/pages/onGoingRide/tripTracker.dart';
import 'package:roadx/src/values/colors.dart' as colors;
import 'package:roadx/src/values/theme.dart' as appTheme;
import 'package:roadx/src/widgets/ModelUtil.dart';
import 'package:roadx/src/widgets/lifecycle/locator.dart';
import 'package:roadx/src/widgets/lifecycle/services/socker_model.dart';
import 'package:roadx/src/widgets/notification_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class App extends StatefulWidget {
  @override
  AppWidgetState createState() => new AppWidgetState();
}

class AppWidgetState extends State<App> {
  GetIt getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
    NotificationHandler().initializeFcmNotification(context);
    setupLocator();
    //
    // Timer.run(() {
    //   navigationPage();
    // });
  }






  @override
  Widget build(BuildContext context) {



    return BlocProvider(
      child:  MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appTheme.theme,
          home: GlobalApp(
              child :HomePage()
          )
      ),
    );
  }
}