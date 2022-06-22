import 'package:flutter/cupertino.dart';

class EditingController extends TextEditingController {

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      // selection: TextSelection.collapsed(offset: newText.length),
      selection: TextSelection(baseOffset: text.length, extentOffset: text.length),
      composing: TextRange.empty,
    );
  }
}