import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:roadx/src/blocs/RideBookedBloc.dart';
import 'package:roadx/src/blocs/auth.bloc.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/models/RideTracker.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/pages/login/login_widget.dart';
import 'package:roadx/src/values/colors.dart';
import 'package:roadx/src/widgets/BoardingScreen/OnboardingModel.dart';
import 'package:roadx/src/widgets/BoardingScreen/OnboardingScreen.dart';
import 'package:roadx/src/widgets/GenericWidget.dart';
import 'package:roadx/src/widgets/lifecycle/services/socker_model.dart';

class ModelUtil {
  static Future<void> neverSatisfied(BuildContext context) async {
    final pages = [
      OnboardingModel(
          title: 'Social Connection',
          description:
              'The “premium experience” for a public transportation fare.',
          titleColor: backgroundColor,
          descripColor: const Color(0xFF434343),
          imagePath: 'assets/images/slide_1.png'),
      OnboardingModel(
          title: 'Memorable Moments',
          description:
              'The “premium experience” for a public transportation fare.',
          titleColor: backgroundColor,
          descripColor: const Color(0xFF434343),
          imagePath: 'assets/images/slide_2.png'),
      OnboardingModel(
          title: 'Fulfilment',
          description:
              'No stress, no lateness, no insecurity and more savings on commuting.',
          titleColor: backgroundColor,
          descripColor: const Color(0xFF434343),
          imagePath: 'assets/images/slide_3.png'),
    ];

    // bool status = await StorageHelper.getBool(StorageKeys.SHOW_FIRST_TIMER_MODAL);
    // bool is_active = await  StorageHelper.getBool(StorageKeys.USER_MODAL_IS_ACTIVE);

    // if (status && is_active) {

    // StorageHelper.setBool(StorageKeys.USER_MODAL_IS_ACTIVE, true);

    var userData = await StorageHelper.get(StorageKeys.client);

    if (userData == "") {
      return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              height: 452.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  OnboardingScreen(
                    bgColor: Colors.white,
                    pages: pages,
                    onPressedSkip: () {
                      StorageHelper.setBool(
                          StorageKeys.USER_MODAL_IS_LOCKED, true);
                      StorageHelper.setBool(
                          StorageKeys.USER_MODAL_IS_ACTIVE, false);
                      StorageHelper.setBool(
                          StorageKeys.SHOW_FIRST_TIMER_MODAL, false);
                      Navigator.pop(context);
                    },
                    onPressedLogin: () {
                      StorageHelper.setBool(
                          StorageKeys.USER_MODAL_IS_LOCKED, true);
                      StorageHelper.setBool(
                          StorageKeys.USER_MODAL_IS_ACTIVE, false);
                      StorageHelper.setBool(
                          StorageKeys.SHOW_FIRST_TIMER_MODAL, false);
                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new LoginWidget()));
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  static Future<void> successRegistration(BuildContext context) async {
    if (StorageHelper.getBool(StorageKeys.SUCCESS_REGISTER) == true) {
      StorageHelper.setBool(StorageKeys.SUCCESS_REGISTER, false);

      return showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
//                    margin: EdgeInsets.all(18),
                    padding: EdgeInsets.all(18),
                    height: 338,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 5,
                          top: 5,
                          child: Opacity(
                            opacity: 0.50,
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: new Image.asset(
                                  "assets/images/cancel_black.png",
                                  width: 21,
                                  height: 21,
                                )),
                          ),
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 21),
                              new Image.asset(
                                "assets/images/successful_register_image.png",
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Congratulation Labby!",
                                style: TextStyle(
                                  color: Color(0xff0000ff),
                                  fontSize: 20,
                                  fontFamily: "Gilroy-Bold",
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                width: 252,
                                height: 50,
                                child: Text(
                                  "Your registration is successful.\nEnjoy the Roadx experience!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: "Gilroy-Regular",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Color(0xff0000ff),
                                    ),
                                    padding: const EdgeInsets.only(
                                      left: 21,
                                      right: 20,
                                      top: 8,
                                      bottom: 9,
                                    ),
                                    child: Text(
                                      "Proceed",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: "Gilroy-Bold",
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ))
                            ]),
                      ],
                    )));
          });
    }
  }

  static Future<void> userRequestNotification(BuildContext context, RideTracker rideTracker) async {

        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0c000000),
                          blurRadius: 30,
                          offset: Offset(0, 30),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: GenericWidget.getAvailablePassebgerNotification(
                        context, rideTracker),
                  ));
            });


  }
}
