import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:roadx/src/helpers/Utils.dart';
import 'package:roadx/src/models/Enums/Enums.dart';
import 'package:roadx/src/models/RideTracker.dart';
import 'package:roadx/src/pages/onGoingRide/tripTracker.dart';
import 'package:roadx/src/repositories/rideTracker.repository.dart';
import 'package:roadx/src/widgets/button.dart';

class GenericWidget {
  static Widget getAvailablePassebgerNotification(
      BuildContext context, RideTracker rideTracker) {
    RideTrackerRepository rideTrackerRepository = RideTrackerRepository();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
        onTap: () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    },
    child:new Column(
          children: <Widget>[
            new Align(
              alignment: Alignment.centerRight,
              child: new Image.asset(
                    "assets/images/cancel_pink.png",
                    width: 25.08,
                    height: 25.08,
                  )
              // ),
            ),
          ],
        )),
        SizedBox(height: 5.92),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              backgroundImage: Utils.getImage(rideTracker != null &&
                      rideTracker.driverRequest != null &&
                      rideTracker.driverRequest.user != null
                  ? rideTracker.driverRequest.user.image
                  : null),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${rideTracker != null && rideTracker.driverRequest != null && rideTracker.driverRequest.user != null ? rideTracker.driverRequest.user.first_name : ""}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                RatingBar.readOnly(
                  initialRating: 3.5,
                  isHalfAllowed: true,
                  halfFilledIcon: Icons.star_half,
                  filledIcon: Icons.star,
                  emptyIcon: Icons.star_border,
                  size: 20,
                ),
                SizedBox(height: 1.76),
                Text(
                  "${rideTracker != null && rideTracker.driverRequest != null && rideTracker.driverRequest.user != null ? rideTracker.driverRequest.user.first_name : ""}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 9,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 5.92),
        Center(
          child: CustomButton(
            onPress: () async => {
              rideTracker.driver_status = RideStatus.approved,
              await rideTrackerRepository.update(rideTracker),
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new TripTrackerWidget()))
            },
            label: "Request Accepted",
            width: 200,
            labelSize: 12,
          ),
        ),
      ],
    );
  }

  static Widget getAvailablePassebger(BuildContext context,
      RideTracker rideTracker) {
    RideTrackerRepository rideTrackerRepository = RideTrackerRepository();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new CircleAvatar(
              radius: 27,
              backgroundColor: Colors.white,
              backgroundImage: Utils.getImage(rideTracker != null &&
                      rideTracker.driverRequest != null &&
                      rideTracker.driverRequest.user != null
                  ? rideTracker.driverRequest.user.image
                  : ""),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${rideTracker != null && rideTracker.driverRequest != null && rideTracker.passengerRequest.user != null ? rideTracker.passengerRequest.user.first_name : ""}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4),
                    RatingBar.readOnly(
                      initialRating: 3.5,
                      isHalfAllowed: true,
                      halfFilledIcon: Icons.star_half,
                      filledIcon: Icons.star,
                      emptyIcon: Icons.star_border,
                    ),
                  ],
                ),
                SizedBox(height: 1.76),
                Text(
                  "${rideTracker != null && rideTracker.driverRequest != null && rideTracker.passengerRequest.user != null ? rideTracker.passengerRequest.user.first_name : ""}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 9,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
        InkWell(
          onTap: () async {
            rideTracker.driver_status = RideStatus.approved;
            await rideTrackerRepository.update(rideTracker);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff0000ff),
            ),
            padding: const EdgeInsets.only(
              top: 2,
              bottom: 3,
            ),
            child: Center(
              child: Text("Accepted",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: "Gilroy",
                    fontWeight: FontWeight.w400,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  static Widget getOnboardPassenger(BuildContext context,
      RideTracker rideTracker) {
    RideTrackerRepository rideTrackerRepository = RideTrackerRepository();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new CircleAvatar(
              radius: 27,
              backgroundColor: Colors.white,
              backgroundImage: Utils.getImage(rideTracker != null &&
                      rideTracker.driverRequest != null &&
                      rideTracker.driverRequest.user != null
                  ? rideTracker.driverRequest.user.image
                  : ""),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${rideTracker != null && rideTracker.driverRequest != null && rideTracker.passengerRequest.user != null ? rideTracker.passengerRequest.user.first_name : ""}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4),
                    RatingBar.readOnly(
                      initialRating: 3.5,
                      isHalfAllowed: true,
                      halfFilledIcon: Icons.star_half,
                      filledIcon: Icons.star,
                      emptyIcon: Icons.star_border,
                    ),
                  ],
                ),
                SizedBox(height: 1.76),
                Text(
                  "${rideTracker != null && rideTracker.driverRequest != null && rideTracker.passengerRequest.user != null ? rideTracker.passengerRequest.user.first_name : ""}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 9,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            CustomButton(onPress: () async => {
              rideTracker.driver_status = RideStatus.end,
              await rideTrackerRepository.update(rideTracker)
            }, label: "End Trip", width: 100, labelSize: 12,),
            CustomButton(onPress: () async => {

            }, label: "Unavailable", width: 100, labelSize: 12,),

          ],
        )
      ],
    );
  }
}
