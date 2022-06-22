//
// import 'package:roadx/src/models/Enums/Enums.dart';
// import 'package:roadx/src/models/RideRequest.dart';
// import 'package:roadx/src/models/UserDetails.dart';
//
// class UserNotification {
//   int id;
//   DrStatus driverStatus;
//   UserDetails userDetails;
//
//   UserNotification({
//     this.id,
//     this.driverStatus,
//     this.userDetails,
//   });
//
//   factory UserNotification.fromJson(Map<String, dynamic> json) {
//     return UserNotification(
//       id: json['id'],
//       driverStatus: json['driverStatus'],
//       userDetails: UserDetails.fromJson(json['rideRequest']),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'driverStatus': driverStatus,
//         'rideRequest': userDetails,
//       };
// }
