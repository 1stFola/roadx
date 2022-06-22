import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roadx/src/blocs/MapModel.dart';
import 'package:roadx/src/models/Enums/Enums.dart';
import 'package:roadx/src/models/RideTracker.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/values/colors.dart';

class DriverOnWay extends StatelessWidget {
  final RideTracker rideTracker;
  final UserDetails user;
  final MapBloc mapModel;

  const DriverOnWay(
      {Key key, @required this.rideTracker, this.user, this.mapModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Temi is 3mins away",
              style: TextStyle(
                color: Color(0xff434343),
                fontSize: 20,
                fontFamily: "Gilroy-Bold",
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xfff5f5f5),
              ),
              padding: const EdgeInsets.only(
                left: 10,
                right: 9,
                top: 6,
                bottom: 7,
              ),
              child: Text(
                "Cancel Trip",
                style: TextStyle(
                  color: Color(0xff7a7a7a),
                  fontSize: 12,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
        Row(
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
                    style: TextStyle(fontSize: 10, color: backgroundColor),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<String>(
                          stream: mapModel.currentAddress,
                          builder: (context, snapshot) {
                            return Text(
                              "${snapshot.data}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF434343),
                                  fontWeight: FontWeight.bold),
                            );
                          }),
                      Container(
                        width: 87,
                        height: 28,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 20,
                              top: 6,
                              child: Text(
                                "Change",
                                style: TextStyle(
                                  color: Color(0xffc9c9c9),
                                  fontSize: 12,
                                  fontFamily: "Gilroy-Bold",
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              width: 87,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color(0xffc4c4c4),
                                  width: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    "Destination",
                    style: TextStyle(fontSize: 10, color: backgroundColor),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getDestination()}",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF434343),
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 87,
                        height: 28,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 20,
                              top: 6,
                              child: Text(
                                "Change",
                                style: TextStyle(
                                  color: Color(0xffc9c9c9),
                                  fontSize: 12,
                                  fontFamily: "Gilroy-Bold",
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              width: 87,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color(0xffc4c4c4),
                                  width: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  driverInformation(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget driverInformation(){
    if(user.id == rideTracker.user.id && rideTracker.driver_status == RideStatus.approved) {
      return
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              child: Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffc4c4c4),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 86.64,
                        height: 62.69,
                        child: Stack(
                          children: [
                            Container(
                              width: 86.64,
                              height: 62.69,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(10),
                                color: Color(0xffc4c4c4),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: 116.68,
                                  height: 127.56,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 43.21),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${getDriver().first_name}",
                  style: TextStyle(
                    color: Color(0xff434343),
                    fontSize: 24,
                    fontFamily: "Gilroy-Bold",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  "${getDriver().rate}",
                  style: TextStyle(
                    color: Color(0xffa5aaae),
                    fontSize: 14,
                    fontFamily: "Gilroy-Regular",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(width: 43.21),
            Text(
              "${getDriver().vehicle_model}\n${getDriver().number_plate}",
              style: TextStyle(
                color: Color(0xffa5aaae),
                fontSize: 18,
                fontFamily: "Gilroy-Bold",
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 43.21),
            Container(
              color: Color(0xff33cc66),
              padding: const EdgeInsets.only(
                left: 15,
                right: 14,
              ),
              child: Opacity(
                opacity: 0.50,
                child: Container(
                  width: 23.72,
                  height: 23.71,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
    }
    return Container();
  }

  UserDetails getDriver() {
    return rideTracker != null &&
            rideTracker.driverRequest != null &&
            rideTracker.driverRequest.user != null
        ? rideTracker.driverRequest.user
        : UserDetails();
  }

  String getDestination() {
    if (user.id == rideTracker.user.id) {
      return rideTracker.passengerRequest.destination.address;
    } else {
      return rideTracker.driverRequest.destination.address;
    }
  }
}
