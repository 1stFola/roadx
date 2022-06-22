
import 'package:flutter/cupertino.dart';

class Library {

  static Widget getImage(String name){

    if(name != null){

      return Image.network(
        'https://placeimg.com/640/480/any',
        fit: BoxFit.fill,
      );
    }
    return Image.asset("assets/images/upload-cloud.png", fit: BoxFit.fill,);
  }
}