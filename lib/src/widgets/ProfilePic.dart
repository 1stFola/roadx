import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roadx/src/models/BusStop.dart';

class ProfilePic extends StatelessWidget {
  final BusStop bus_stop;

  const ProfilePic({Key key, this.bus_stop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        bus_stop.formatted_address,
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Color.fromRGBO(165, 170, 174, 1),
            fontFamily: 'Gilroy-Regular',
            fontSize: 18,
            letterSpacing:
                0 /*percentages not used in flutter. defaulting to zero*/,
            fontWeight: FontWeight.normal,
            height: 1),
      ),
      leading:  new Image(
        height: 25.0,
        width: 25.0,
        image: new AssetImage("assets/images/busstop_icon.png"),
      ),
    );
  }
}

