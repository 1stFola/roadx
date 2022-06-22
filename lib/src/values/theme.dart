import 'package:flutter/material.dart';
import 'colors.dart' as colors;

final ThemeData theme = ThemeData(
  primaryColor: colors.backgroundColor,
  accentColor: colors.accentColor,
  scaffoldBackgroundColor: Colors.white,

  appBarTheme: AppBarTheme(
    color: colors.backgroundColor,
    iconTheme: IconThemeData(color: colors.accentLightColor)
  ),

  buttonTheme: ButtonThemeData(
    buttonColor: colors.accentLightColor,
    disabledColor: colors.primaryColorDark
  )
);
