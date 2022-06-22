import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roadx/src/helpers/BasicShapeUtils.dart';
import 'package:roadx/src/models/CarTypeMenu.dart';

class CarSelectionCard extends StatelessWidget {
  final CarTypeMenu carTypeMenu;
  final Color color;

  const CarSelectionCard({Key key, this.carTypeMenu, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        shape: ShapeUtils.rounderCard,
        color: color,
        elevation: 1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        carTypeMenu.rideType,
                        style:
                        TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        "Space Bus",
                        style:
                        TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        carTypeMenu.info,
                        style:
                        TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                )),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Image.asset(
                  carTypeMenu.image,
                  width: 292,
                  height: 149,
                    alignment:Alignment.centerLeft,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
