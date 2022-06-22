import 'package:fluttertoast/fluttertoast.dart';
import 'package:roadx/src/values/colors.dart' as colors;
import 'package:roadx/src/values/dimens.dart' as dimens;

class CustomToast {
  static void show(String msg) => Fluttertoast.showToast(
    msg: msg ?? "",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
//    timeInSecForIos: 1,
    backgroundColor: colors.toastBackgroundColor,
    textColor: colors.toastTextColor,
    fontSize: dimens.fontText
  );

  static void cancelAll() => Fluttertoast.cancel();
}