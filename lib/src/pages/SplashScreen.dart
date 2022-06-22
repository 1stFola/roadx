import 'dart:async';
import 'package:flutter/material.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/pages/home/home_widget.dart';
import 'package:roadx/src/values/colors.dart';

import 'availablePassenger/available_passenger_widget.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final splashDelay = 3;

  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/logo.png',
                            height: 300,
                            width: 300,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                          ),
                        ],
                      )),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      // CircularProgressIndicator(),
                      // Container(
                      //   height: 10,
                      // ),
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: <Widget>[
                      //       Spacer(),
                      //       Text(_versionName),
                      //       Spacer(
                      //         flex: 4,
                      //       ),
                      //       Text('androing'),
                      //       Spacer(),
                      //     ])
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}