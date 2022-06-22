import 'package:flutter/material.dart';
import 'package:roadx/src/values/colors.dart' as colors;

class CustomButton extends StatelessWidget {
  final String label;
  final double labelSize;
  final double width;
  final Function onPress;
  final bool disabled;
  final bool grey;
  final double _elevation = 3;

  const CustomButton(
      {Key key, this.label, this.labelSize, this.width, this.onPress, this.disabled, this.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final action = disabled == true ? null : onPress;

    Color backgroundColor = colors.backgroundColor;
    Color textColor = Colors.white;

    if (grey == true) {
      backgroundColor = colors.greyColor;
    }

    // return StreamBuilder<bool>(
    //     stream: value,
    //     builder: (context, snapshot) =>

    return SizedBox(
      width: width ?? double.infinity, // match_parent
      child:

      RaisedButton(
          color: colors.backgroundColor,
          splashColor: Colors.black26,
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 36.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          disabledColor: backgroundColor,
          disabledTextColor: textColor,
          onPressed: action,
          elevation: _elevation,
          child: Text(
            label ?? "Label",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: labelSize ?? 17,
              fontFamily: "DM Sans",
              fontWeight: FontWeight.w700,
            ),
          )),
    );
    //);
  }
}
