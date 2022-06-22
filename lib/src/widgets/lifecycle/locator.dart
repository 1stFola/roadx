

import 'package:get_it/get_it.dart';
import 'package:roadx/src/widgets/lifecycle/services/background_fetch_service.dart';
import 'package:roadx/src/widgets/lifecycle/services/location_service.dart';
import 'package:roadx/src/widgets/lifecycle/services/socker_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => BackgroundFetchService());
  // locator.registerSingleton<SocketModel>(AppModelImplementation(),
  //     signalsReady: true);
}