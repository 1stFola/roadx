

import 'package:roadx/src/models/Enums/Enums.dart';
import 'package:roadx/src/models/UserDetails.dart';

class UserLoggedInEvent {
  UserDetails userDetails;

  UserLoggedInEvent(this.userDetails);
}

// class DriverStatusInEvent {
//   DriverStatus driverStatus;
//
//   DriverStatusInEvent(this.driverStatus);
// }


class StringInEvent{
  String string;

  StringInEvent(this.string);
}
