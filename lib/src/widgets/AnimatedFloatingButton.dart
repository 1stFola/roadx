
import 'package:flutter/material.dart';

class AnimatedFloatingButton extends StatefulWidget {
  final List<AnimatedFloatingText> fabButtons;
  final Color colorStartAnimation;
  final Color colorEndAnimation;
  final Widget animatedIconData;

  AnimatedFloatingButton(
      {Key key,
        this.fabButtons,
        this.colorStartAnimation,
        this.colorEndAnimation,
        this.animatedIconData})
      : super(key: key);

  @override
  _AnimatedFloatingActionButtonState createState() =>
      _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState
    extends State<AnimatedFloatingButton>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: widget.colorStartAnimation,
      end: widget.colorEndAnimation,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: widget.animatedIconData,

      ),
    );
  }


  List<Widget> _setFabButtons() {
    List<Widget> processButtons = List<Widget>();
    for (int i = 0; i < widget.fabButtons.length; i++) {

      var intervalValue = i == 0
          ? 0.9
          : ((widget.fabButtons.length - i) /
          widget.fabButtons.length) -
          0.2;

      intervalValue =
      intervalValue < 0.0 ? (1 / i) * 0.5 : intervalValue;

      processButtons.add(
              Row(
            children: <Widget>[
              ScaleTransition(
                  scale: CurvedAnimation(
                    parent: this._animationController,
                    curve:
                    Interval(intervalValue, 1.0, curve: Curves.linear),
                  ),
                  alignment: FractionalOffset.center,
                  child: Container(
                      padding:
                      EdgeInsets.only(right: 4),
                      child: widget.fabButtons[i].returnLabel())),

              ScaleTransition(
                  scale: CurvedAnimation(
                    parent: this._animationController,
                    curve:
                    Interval(intervalValue, 1.0, curve: Curves.linear),
                  ),
                  alignment: FractionalOffset.center,
                  child: widget.fabButtons[i])

//              TransformFloatButton(
//                floatButton: widget.fabButtons[i],
//                translateValue: _translateButton.value * (widget.fabButtons.length - i),
//              )
            ],
          )
      );
    }
    processButtons.add(toggle());
    return processButtons;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: _setFabButtons(),
    );
  }
}



class AnimatedFloatingText extends FloatingActionButton {
  final FloatingActionButton currentButton;
  final String labelText;
  final double labelFontSize;
  final Color labelColor;
  final Color labelBackgroundColor;
  final Color labelShadowColor;
  final bool labelHasShadow;
  final bool hasLabel;

  AnimatedFloatingText(
      {this.currentButton,
        this.labelText,
        this.labelFontSize = 14.0,
        this.labelColor,
        this.labelBackgroundColor,
        this.labelShadowColor,
        this.labelHasShadow = true,
        this.hasLabel = false})
      : assert(currentButton != null);

  Widget returnLabel() {
    return Container(
        decoration: BoxDecoration(
            boxShadow: this.labelHasShadow
                ? [
              new BoxShadow(
                color: this.labelShadowColor == null
                    ? Color.fromRGBO(204, 204, 204, 1.0)
                    : this.labelShadowColor,
                blurRadius: 3.0,
              ),
            ]
                : null,
            color: this.labelBackgroundColor == null
                ? Colors.white
                : this.labelBackgroundColor,
            borderRadius: BorderRadius.circular(3.0)), //color: Colors.white,
        padding: EdgeInsets.all(9.0),
        child: Text(this.labelText,
            style: TextStyle(
                fontSize: this.labelFontSize,
                fontWeight: FontWeight.bold,
                color: this.labelColor == null
                    ? Color.fromRGBO(119, 119, 119, 1.0)
                    : this.labelColor)));
  }


  Widget build(BuildContext context) {
    return this.currentButton;
  }
}