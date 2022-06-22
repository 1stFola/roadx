

import 'package:get_it/get_it.dart';
import 'package:roadx/src/widgets/lifecycle/services/stoppable_service.dart';
import 'package:location/location.dart' as location;


class LocationService extends StoppableService {
  location.Location _location = location.Location();
  GetIt getIt = GetIt.instance;

  @override
  Future<void> start() async {
    super.start();

    /*
    Know if your user is current a drivr or not
    //  */
    // bool isDriver = await StorageHelper.getBool(StorageKeys.isDriver);
    //
    // var userData = await StorageHelper.get(StorageKeys.client);
    // if (userData != null) {
    //   var userDetails = UserDetails.fromJson(jsonDecode(userData));
    //
    //   Future.delayed(const Duration(seconds: 5), () {
    //     _location.onLocationChanged.listen((event) async {
    //       Map<String, dynamic> attributeMap = new Map<String, dynamic>();
    //       attributeMap["latitude"] = event.latitude;
    //       attributeMap["longitude"] = event.longitude;
    //       attributeMap["user_id"] = userDetails.id;
    //       attributeMap["isDriver"] = isDriver;
    //       attributeMap["first_name"] = userDetails.first_name;
    //       attributeMap["last_name"] = userDetails.last_name;
    //       getIt<SocketModel>().socket.emit("current_position", attributeMap);
    //     });
    //   });
    //
    //
    // }
    // print('LocationService Started $serviceStopped');
  }

  @override
  void stop() {
    super.stop();
    print('LocationService Stopped $serviceStopped');
  }
}
