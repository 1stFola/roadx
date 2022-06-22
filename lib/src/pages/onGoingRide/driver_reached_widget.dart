import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:roadx/src/blocs/MapModel.dart';
import 'package:roadx/src/helpers/Utils.dart';
import 'package:roadx/src/models/RideTracker.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/widgets/button.dart';

class DriverReachedWidget extends StatelessWidget {
  final RideTracker rideTracker;
  final UserDetails user;
  final MapBloc mapModel;

  const DriverReachedWidget({Key key, @required this.rideTracker, this.user, this.mapModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Trip Completed",
          style: TextStyle(
            color: Color(0xff434343),
            fontSize: 20,
            fontFamily: "Gilroy-Bold",
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        new Center(
          child: rideTracker != null &&
                  rideTracker.driverRequest != null &&
                  rideTracker.driverRequest.user != null &&
                  rideTracker.driverRequest.user.image != null
              ? new CircleAvatar(
                  radius: 67,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      Utils.getImage(rideTracker.driverRequest.user.image),
                )
              : new CircleAvatar(
                  radius: 67,
                  backgroundColor: Colors.white,
                  backgroundImage: new AssetImage("assets/images/avatar.jpg"),
                ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          rideTracker != null &&
                  rideTracker.driverRequest != null &&
                  rideTracker.driverRequest.user != null
              ? "Rate " + rideTracker.driverRequest.user.label
              : "--",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: "Gilroy-Bold",
            fontWeight: FontWeight.w400,
          ),
        ),

        new Center(
            child: RatingBar(
                initialRating: 3,
                isHalfAllowed: true,
                halfFilledIcon: Icons.star_half,
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                filledColor: Color(0xFFFFCA41),
                size: 48,
                onRatingChanged: (rating) => {})),
        Container(
          width: 137,
          height: 38.50,
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 137,
                    height: 34.29,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 36.94,
                          top: 0,
                          child: Text(
                            "Time:",
                            style: TextStyle(
                              color: Color(0xff434343),
                              fontSize: 10,
                              fontFamily: "Gilroy-Regular",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 89,
                          top: 0,
                          child: Text(
                            "Distance:",
                            style: TextStyle(
                              color: Color(0xff434343),
                              fontSize: 10,
                              fontFamily: "Gilroy-Regular",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              rideTracker != null &&
                                      rideTracker.duration != null
                                  ? rideTracker.duration.toString() + " Mins"
                                  : "",
                              style: TextStyle(
                                color: Color(0xff303030),
                                fontSize: 18,
                                fontFamily: "Gilroy-Bold",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              rideTracker != null &&
                                      rideTracker.distance != null
                                  ? rideTracker.distance.toString() + " Km"
                                  : "",
                              style: TextStyle(
                                color: Color(0xff303030),
                                fontSize: 18,
                                fontFamily: "Gilroy-Bold",
                                fontWeight: FontWeight.w400,
                              ),
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
        Text(
          "N200",
          style: TextStyle(
            color: Color(0xffff8041),
            fontSize: 40,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
          ),
        ),
        CustomButton(onPress: () async => {}, label: "Pay now", width: 158),
      ],
    );
  }
}
