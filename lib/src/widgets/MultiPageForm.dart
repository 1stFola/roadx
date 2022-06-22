import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roadx/src/values/colors.dart';
import 'package:roadx/src/widgets/button.dart';

class MultiPageForm extends StatefulWidget {
  final VoidCallback onFormSubmitted;
  final int totalPage;
  final int nextPage;
  final Widget nextButtonStyle;
  final Widget previousButtonStyle;
  final Widget submitButtonStyle;
  final List<Widget> pageList;

  MultiPageForm({
    @required this.totalPage,
    @required this.pageList,
    @required this.onFormSubmitted,
    this.nextButtonStyle,
    this.previousButtonStyle,
    this.submitButtonStyle,
    this.nextPage,
  });

  _MultiPageFormState createState() => _MultiPageFormState();
}

class _MultiPageFormState extends State<MultiPageForm> {
  int totalPage;
  int currentPage = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalPage = widget.totalPage;
    if (widget.nextPage != null) {
      currentPage++;
    }
  }

  Widget getNextButtonWrapper(Widget child) {
    if (widget.nextButtonStyle != null) {
      return child;
    } else {
      return Text("Next");
    }
  }

  Widget getPreviousButtonWrapper(Widget child) {
    if (widget.previousButtonStyle != null) {
      return child;
    } else {
      return Text("Previous");
    }
  }

  Widget getSubmitButtonWrapper(Widget child) {
    if (widget.previousButtonStyle != null) {
      return child;
    } else {
      return Text("Submit");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: pageHolder(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                currentPage == 1
                    ? Container()
                    : FlatButton(
                        color: backgroundColor,
                        splashColor: Colors.black26,
                        padding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 36.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: backgroundColor,
                        child: Text(
                          "Previous",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: "DM Sans",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            currentPage = currentPage - 1;
                          });
                        },
                      ),
                currentPage == totalPage
                    ? FlatButton(
                        child: getSubmitButtonWrapper(widget.submitButtonStyle),
                        onPressed: widget.onFormSubmitted,
                      )
                    : FlatButton(
                        color: backgroundColor,
                        splashColor: Colors.black26,
                        padding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 36.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: backgroundColor,
                        child: Text(
                          "Next",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: "DM Sans",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            currentPage = currentPage + 1;
                          });
                        },
                      ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5,)
      ],
    );
  }

  Widget pageHolder() {
    for (int i = 1; i <= totalPage; i++) {
      if (currentPage == i) {
        return widget.pageList[i - 1];
      }
    }
    return Container();
  }
}
