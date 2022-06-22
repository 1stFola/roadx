import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:roadx/src/blocs/MapModel.dart';
import 'package:roadx/src/blocs/auth.bloc.dart';
import 'package:roadx/src/helpers/storage/storage.helper.dart';
import 'package:roadx/src/helpers/storage/storage.keys.dart';
import 'package:roadx/src/models/BusStop.dart';
import 'package:roadx/src/models/UserDetails.dart';
import 'package:roadx/src/models/binder/BindRideRequest.dart';
import 'package:roadx/src/pages/EmptyScreen/EmptyContent.dart';
import 'package:roadx/src/pages/availableDriver/available_driver_widget.dart';
import 'package:roadx/src/pages/chooseRide/choose_ride_widget.dart';
import 'package:roadx/src/pages/login/login_widget.dart';
import 'package:roadx/src/widgets/PredictionItemView.dart';

/// An list picker like Widget with textField to show
/// AutoComplete just like Google Maps,
/// @Required : TextField
/// @Optional Data and onTap Callback
typedef onListItemTap = void Function(BusStop prediction);


class PredictionsLIstPlace extends StatefulWidget {
  final List<BusStop> pickupPredictions;
  final List<BusStop> destinationPredictions;
  final List<BusStop> favourites;
  final onListItemTap pickupPredictionTap;
  final onListItemTap destinationPredictionTap;
  final onListItemTap favouriteTap;
  final onListItemTap selectedPickupPredictions;

  PredictionsLIstPlace({
    Key key,
    this.pickupPredictions,
    this.pickupPredictionTap,
    this.destinationPredictions,
    this.destinationPredictionTap,
    this.favourites,
    this.favouriteTap,
    this.selectedPickupPredictions,
  }) : super(key: key);

  @override
  _PredictionsLIstPlaceState createState() => _PredictionsLIstPlaceState();
}

class _PredictionsLIstPlaceState extends State<PredictionsLIstPlace> {


  bool isPickup = false;
  AuthBloc userDetails;
  MapBloc mapModel;
  List<BusStop> data = new List<BusStop>();
  onListItemTap onTap;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    mapModel = Provider.of<MapBloc>(context);
    userDetails = Provider.of<AuthBloc>(context);
  }

  @override
  void dispose() {
    userDetails.dispose();
    mapModel.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserDetails>(
        stream: userDetails.user,
        initialData: new UserDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return view(snapshot.data);
          else
            return view(null);
        });
  }

  @override
  Widget view(UserDetails userDetails) {

    if (widget != null) {
      if (widget.destinationPredictions != null && widget.destinationPredictions.length > 0) {
        data = widget.destinationPredictions;
        onTap = widget.destinationPredictionTap;
        isPickup = false;
      } else if (widget.pickupPredictions != null && widget.pickupPredictions.length > 0) {
        data = widget.pickupPredictions;
        onTap = widget.pickupPredictionTap;
        isPickup = true;
      }
    }

    if (data != null && data.length == 0)
      return EmptyContent(message: "Content is empty");

    return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (BuildContext ctxt, int index) {
          BusStop busStop = data[index];
          return InkResponse(
              onTap: () => {
                    onTap(
                      busStop,
                    ),
                    getContent(busStop, userDetails)
                  },
              child: BusStopItemView(bus_stop: data[index]));
        });
  }


  void getContent(BusStop busStop, UserDetails userDetails){
    if(isPickup){
      widget.selectedPickupPredictions(busStop);
      setState(() {
        data =  new List<BusStop>();
      });
    }else{
      getTunn(userDetails);
    }
  }

  Future<void> getTunn(UserDetails user) async {

    if(user == null || user != null && user.id == null){
      /*
      Redirect to the screen
       */
      await StorageHelper.setBool(StorageKeys.REDIRECT_CHOOSE_RIDE, true);
      Navigator.push(context, new MaterialPageRoute(builder: (context) => new LoginWidget()));
    }else if (!isPickup) {
      if (mapModel.getChoiceRide()) {
        BindRideRequest ride = new BindRideRequest();
        ride.journey_id = mapModel.destinationBusstop.journey_id;
        ride.destination_id = mapModel.destinationBusstop.id;
        ride.start_id = mapModel.pickupBusstop.id;
        ride.carType = "B";
        ride.driver = true;
        await mapModel
            .rideRequest(ride)
            .then((value) => {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new AvailableDriverWidget()))
                })
            .catchError((onError) => {
                  Fluttertoast.showToast(
                      msg: onError.toString(),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0)
                });
      } else {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new ChooseRideWidget()));
      }
    }
  }
}
