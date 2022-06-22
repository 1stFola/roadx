import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  final String message;

  const EmptyContent({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            new Image.asset(
              'assets/images/empty_content.png',
              width: 258,
              height: 201,
            ),
            SizedBox(height: 30),
            new Container(
              width: 258,
              child: new Text(
                "${message == null ? 'Looks like you don’t have any content yet or you can pull to refresh' : message}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.0, color: Color(0xFF333333)),
              ),
            ),
            SizedBox(height: 40),


          ],
        )),
    );
  }
}
