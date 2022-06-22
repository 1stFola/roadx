import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:roadx/src/models/RideRequest.dart';
import 'package:roadx/src/pages/EmptyScreen/EmptyContent.dart';
import 'package:roadx/src/repositories/ride.repository.dart';
import 'package:roadx/src/values/colors.dart';
import 'package:roadx/src/widgets/CustomAppBar.dart';
import 'package:stream_loader/stream_loader.dart';


class RideHistoryWidget extends StatefulWidget {
  @override
  _UsdPageState createState() => _UsdPageState();
}

class _UsdPageState extends State<RideHistoryWidget> {
  RideRepository rideRepository = RideRepository();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: CustomAppBar(
            height: 130,
            child: Stack(children: <Widget>[
              Image.asset(
                "assets/images/profile_header.png",
                fit: BoxFit.fitWidth,
                height: 130,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppBar(
                    centerTitle: true,
                    title: Text(
                      "Your Ride History",
                      style: new TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.transparent,
                    leading: new IconButton(
                        color: Colors.white,
                        icon: new Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                          ;
                        }),
                    elevation: 0,
                  ),
                ],
              ),
            ])),
        body: LoaderWidget<BuiltList<RideRequest>>(
            blocProvider: () => LoaderBloc(
                  loaderFunction: getHistory,
                  refresherFunction: getHistory,
                  initialContent: BuiltList.of([]),
                  // enableLogger: true,
                ),
            messageHandler: (message, _) => handleMessage(message, context),
            builder: (context, state, bloc) {
              if (state.error != null) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Error: ${state.error}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      RaisedButton(
                        onPressed: bloc.fetch,
                        child: Text('Retry'),
                      )
                    ],
                  ),
                );
              }
              if (state.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.grey),
                  ),
                );
              }

              if (state.content.length == 0)
                return RefreshIndicator(
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: EmptyContent(message: "Ride History is Empty"),
                      ),
                      ListView()
                    ],
                  ),
                  onRefresh: bloc.refresh,
                );

              return RefreshIndicator(
                child: ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: state.content.length,
                  itemBuilder: (context, index) {
                    var comment = state.content[index];
                    return content(comment, bloc);
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),
                onRefresh: bloc.refresh,
              );
            }));
  }

  Widget content(RideRequest rideRequest, bloc) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 25, right: 10, left: 10, bottom: 10),
            child: SizedBox(
                height: 65,
                child: Image.asset(
                  "assets/images/location_indicator.png",
                  fit: BoxFit.fitHeight,
                )),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Start",
                  style: TextStyle(fontSize: 10, color: backgroundColor),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "${rideRequest.start != null ? rideRequest.start.address : "--"}",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8A8A8A),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Destination",
                  style: TextStyle(fontSize: 10, color: backgroundColor),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  "${rideRequest.destination != null ? rideRequest.destination.address : "--"}",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8A8A8A),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(top: 70),
            child:  InkWell(
              onTap: (){
                Fluttertoast.showToast(
                    msg: 'loading...',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
                rideRepository.delete(rideRequest.id);
                bloc.refresh();
              },
            child: Image.asset(
              "assets/images/delete_icon.png",
              fit: BoxFit.fitHeight,
            ),
            )
            ,
          ),
        ],
      ),
    );
  }

  Stream<BuiltList<RideRequest>> getHistory() async* {
    final response = await rideRepository.getHistory();

    yield response.toBuiltList();
  }
}

void handleMessage(LoaderMessage message, BuildContext context) {
  message.fold(
      onFetchFailure: (error, stackTrace) => {
            Fluttertoast.showToast(
                msg: 'Fetch error',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0)
          },
      onFetchSuccess: (_) {},
      onRefreshSuccess: (data) => {
//            Fluttertoast.showToast(
//                msg: 'Refresh success',
//                toastLength: Toast.LENGTH_SHORT,
//                gravity: ToastGravity.BOTTOM,
//                timeInSecForIosWeb: 1,
//                backgroundColor: Colors.red,
//                textColor: Colors.white,
//                fontSize: 16.0)
          },
      onRefreshFailure: (error, stackTrace) => {
            Fluttertoast.showToast(
                msg: 'Refresh error',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0)
          });
}
