import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:roadx/src/application.dart';
import 'src/app.dart';


void main() async {
  await Application.getInstance().init();
  Application.getInstance().isDebug = true;
  debugPaintSizeEnabled = false;
  runApp(App());
}


