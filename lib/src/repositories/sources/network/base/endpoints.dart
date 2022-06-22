import 'base_url.dart' as BASE_URL;

class _Auth {
  final login = BASE_URL.base + "login";
  final socialLogin = BASE_URL.base + "socialLogin";
  final register = BASE_URL.base + "register";
  final confirmAccount = BASE_URL.base + "confirmAccount";
  final passwordCreate = BASE_URL.base + "password/create";
  final passwordReset = BASE_URL.base + "password/reset";
}

class _User {
  final details = BASE_URL.base + "profile";
  final update = BASE_URL.base + "profile/edit";
  final profile_picture = BASE_URL.base + "file/";
  final kyc = BASE_URL.base + "profile/kyc";
}

class _Map {
  final location = BASE_URL.base + "location";
  final autoComplete = BASE_URL.base + "busstop/autoComplete";
  final destinationPoint = BASE_URL.base + "busstop/destinationPoint";
  final nearestBusstop = BASE_URL.base + "busstop/nearestBusstop";

}
class _Ride {
  final getAvailableRide = BASE_URL.base + "rideRequest/getAvailableRide";
  final rideRequest = BASE_URL.base + "rideRequest";
  final rideTracker = BASE_URL.base + "rideTracker";
  final getOnboardPassengers = BASE_URL.base + "rideRequest/getOnboardPassengers";
}

final auth = _Auth();
final user = _User();
final map = _Map();
final ride = _Ride();
