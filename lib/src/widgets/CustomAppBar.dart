import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final Widget child;
  final double height;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;

  CustomAppBar({@required this.child, this.padding, this.height = kToolbarHeight, this.alignment});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
//      padding: EdgeInsets.only(left: 20, right: 20),
      height: preferredSize.height,
      color: Colors.white,
      alignment: alignment == null ? Alignment.center : alignment,
      child: child,
    );
  }
}