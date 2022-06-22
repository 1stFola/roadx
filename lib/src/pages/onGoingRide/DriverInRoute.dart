// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:roadx/src/models/RideTracker.dart';
// import 'package:roadx/src/models/UserDetails.dart';
// import 'package:roadx/src/values/colors.dart';
//
// class DriverInRoute extends StatelessWidget {
//
//   final RideTracker rideTracker;
//
//   const DriverInRoute({Key key, @required this.rideTracker}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return  Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "${getDriver().first_name} is 3mins away",
//                   style: TextStyle(
//                     color: Color(0xff434343),
//                     fontSize: 20,
//                     fontFamily: "Gilroy-Bold",
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Color(0xfff5f5f5),
//                   ),
//                   padding: const EdgeInsets.only(
//                     left: 10,
//                     right: 9,
//                     top: 6,
//                     bottom: 7,
//                   ),
//                   child: Text(
//                     "Cancel Trip",
//                     style: TextStyle(
//                       color: Color(0xff7a7a7a),
//                       fontSize: 12,
//                       fontFamily: "Montserrat",
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       top: 25, right: 10, left: 10, bottom: 10),
//                   child: SizedBox(
//                       height: 75,
//                       child: Image.asset(
//                         "assets/images/location_indicator.png",
//                         fit: BoxFit.fitHeight,
//                       )),
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Current Position",
//                         style: TextStyle(fontSize: 10, color: backgroundColor),
//                       ),
//                       SizedBox(
//                         height: 5.0,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "dsdsdsdsdsi",
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 color: Color(0xFF434343),
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Container(
//                             width: 87,
//                             height: 28,
//                             child: Stack(
//                               children: [
//                                 Positioned(
//                                   left: 20,
//                                   top: 6,
//                                   child: Text(
//                                     "Change",
//                                     style: TextStyle(
//                                       color: Color(0xffc9c9c9),
//                                       fontSize: 12,
//                                       fontFamily: "Gilroy-Bold",
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 87,
//                                   height: 28,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     border: Border.all(
//                                       color: Color(0xffc4c4c4),
//                                       width: 1,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: 25.0,
//                       ),
//                       Text(
//                         "Destination",
//                         style: TextStyle(fontSize: 10, color: backgroundColor),
//                       ),
//                       SizedBox(
//                         height: 5.0,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "dsdsdsdsdsi",
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 color: Color(0xFF434343),
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Container(
//                             width: 87,
//                             height: 28,
//                             child: Stack(
//                               children: [
//                                 Positioned(
//                                   left: 20,
//                                   top: 6,
//                                   child: Text(
//                                     "Change",
//                                     style: TextStyle(
//                                       color: Color(0xffc9c9c9),
//                                       fontSize: 12,
//                                       fontFamily: "Gilroy-Bold",
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 87,
//                                   height: 28,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     border: Border.all(
//                                       color: Color(0xffc4c4c4),
//                                       width: 1,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 64,
//                             height: 64,
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   width: 64,
//                                   height: 64,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Color(0xffc4c4c4),
//                                   ),
//                                 ),
//                                 Positioned.fill(
//                                   child: Align(
//                                     alignment: Alignment.bottomRight,
//                                     child: Container(
//                                       width: 86.64,
//                                       height: 62.69,
//                                       child: Stack(
//                                         children: [
//                                           Container(
//                                             width: 86.64,
//                                             height: 62.69,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                               BorderRadius.circular(10),
//                                               color: Color(0xffc4c4c4),
//                                             ),
//                                           ),
//                                           Positioned.fill(
//                                             child: Align(
//                                               alignment: Alignment.topLeft,
//                                               child: Container(
//                                                 width: 116.68,
//                                                 height: 127.56,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(width: 43.21),
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                "${ getDriver().first_name }",
//                                 style: TextStyle(
//                                   color: Color(0xff434343),
//                                   fontSize: 24,
//                                   fontFamily: "Gilroy-Bold",
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               SizedBox(height: 1),
//
//                               Row(
//                                 children: [
//                                   Image.asset(
//                                     "assets/images/star.png",
//                                     width: 19.24,
//                                     height: 19.24,
//                                   ),
//                                   SizedBox(height: 2),
//                                   Text(
//                                     "4.90",
//                                     style: TextStyle(
//                                       color: Color(0xffa5aaae),
//                                       fontSize: 14,
//                                       fontFamily: "Gilroy-Regular",
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ],
//                               )
//
//
//                             ],
//                           ),
//                           SizedBox(width: 43.21),
//
//
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//
//                               Text(
//                                 "Toyota Corolla",
//                                 style: TextStyle(
//                                   color: Color(0xffa5aaae),
//                                   fontSize: 18,
//                                   fontFamily: "Gilroy-Bold",
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//
//                               Text(
//                                 "AA 456 AGL",
//                                 style: TextStyle(
//                                   color: Color(0xffa5aaae),
//                                   fontSize: 18,
//                                   fontFamily: "Gilroy-Bold",
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               )
//                             ],
//                           ),
//
//                           SizedBox(width: 43.21),
//
//
//                           InkWell(
//                             onTap: (){
//
//                             },
//                             child: Image.asset(
//                               "assets/images/star.png",
//                               width: 19.24,
//                               height: 19.24,
//                             ),
//                           ),
//
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//   }
//
//   UserDetails getDriver(){
//     return rideTracker != null &&  rideTracker.driverRequest != null && rideTracker.driverRequest.user != null ? rideTracker.driverRequest.user : UserDetails();
//   }
// }
