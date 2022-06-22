import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roadx/src/helpers/EditingController.dart';
import 'package:roadx/src/values/colors.dart' as colors;
import 'package:roadx/src/values/dimens.dart' as dimens;

class EditText extends StatefulWidget {
  final bool autofocus;
  final Stream<dynamic> value;
  final Function(dynamic) onChange;
  final String placeholder;
  final TextInputType keyboardType;
  final bool password;
  final bool dark;
  final bool multiline;
  final String labelText;
  final String mask;

  const EditText(
      {Key key,
      this.autofocus,
      this.value,
      this.onChange,
      this.placeholder,
      this.keyboardType,
      this.password,
      this.dark,
      this.multiline,
      this.labelText,
      this.mask})
      : super(key: key);

  @override
  _EditTextState createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  bool _obscureText = true;
  final _controller = EditingController();

  @override
  void initState() {

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: widget.value,
        builder: (context, snapshot) {
          var value = snapshot.hasData ? snapshot.data : "";
          var controller = null;
          if(value != "") {
          _controller.value = TextEditingValue(
            text: value,
            selection: TextSelection.fromPosition(
              TextPosition(offset: value.length),
            ),
          );
            controller = _controller;
          }
          return Theme(
            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
            child: widget.password == true
                ? TextField(
                    // controller: _controller,
                    obscureText: _obscureText,
                    onChanged: widget.onChange,
                    maxLines: widget.multiline == true ? null : 1,
                    keyboardType: widget.multiline == true
                        ? TextInputType.multiline
                        : widget.keyboardType,
                    style: TextStyle(
                        color: widget.dark == true
                            ? colors.backgroundColor
                            : colors.editTextColor //cor do texto ao digitar,
                        ),
                    autofocus: widget.autofocus == null ? false : true,
                    textCapitalization: TextCapitalization.none,

                    decoration: new InputDecoration(
                      labelText: widget.labelText == null
                          ? widget.placeholder
                          : widget.labelText,
                      errorText: snapshot.error,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffD9D8F1),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffD9D8F1),
                        ),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffD9D8F1),
                        ),
                      ),
                      suffixIcon: new GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: new Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                  )
                : TextField(
                    controller: controller,
                    onChanged: widget.onChange,
                    maxLines: widget.multiline == true ? null : 1,
                    keyboardType: widget.multiline == true
                        ? TextInputType.multiline
                        : widget.keyboardType,
                    style: TextStyle(
                        color: widget.dark == true
                            ? colors.backgroundColor
                            : colors.editTextColor
                        ),
                    autofocus: widget.autofocus == null ? false : true,
                    textCapitalization: TextCapitalization.none,

                    decoration: new InputDecoration(
                      errorText: snapshot.error,
                      labelText: widget.labelText == null
                          ? widget.placeholder
                          : widget.labelText,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffD9D8F1),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffD9D8F1),
                        ),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffD9D8F1),
                        ),
                      ),
                    ),
                  ),
          );
        });
  }
}
