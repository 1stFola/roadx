import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roadx/src/values/colors.dart';
import 'package:roadx/src/widgets/BoardingScreen/OnboardingModel.dart';

//https://github.com/UrAvgDeveloper/onboarding_flutter/blob/master/lib/pages/onboarding_page.dart
class OnboardingScreen extends StatefulWidget {
  final List<OnboardingModel> pages;
  final Color bgColor;
  final GestureTapCallback onPressedSkip;
  final GestureTapCallback onPressedLogin;

  OnboardingScreen({
    Key key,
    @required this.pages,
    @required this.bgColor,
    @required this.onPressedSkip,
    @required this.onPressedLogin,
  }) : super(key: key);

  @override
  createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.pages.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  List<Widget> buildOnboardingPages() {
    final children = <Widget>[];

    for (int i = 0; i < widget.pages.length; i++) {
      children.add(_showPageData(widget.pages[i]));
    }
    return children;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? backgroundColor : Color(0xFF929794),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.bgColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Container(
                      child: new Image(
                    height: 25.0,
                    width: 113.0,
                    image: new AssetImage("assets/images/logo_black.png"),
//                        fit: BoxFit.fill,
                  )),
                  Container(
                    height: 300,
                    color: Colors.transparent,
                    child: PageView(
                        physics: ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: buildOnboardingPages()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: InkWell(
                    onTap: widget.onPressedSkip,
                    child: Container(
                      height: 43,
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Color(0xff0000ff),
                          width: 1,
                        ),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 9,
                      ),
                      child: Center(
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            color: Color(0xff0000ff),
                            fontSize: 20,
                            fontFamily: "Gilroy-Bold",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: widget.onPressedLogin,
                  child: Container(
                    height: 43,
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xff0000ff),
                    ),
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 9,
                    ),
                    child: Center(
                      child:Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "Gilroy-Bold",
                        fontWeight: FontWeight.w400,
                      ),),
                    ),
                  ),
                ),
              ),
//                  child: new Container(
//                      decoration: BoxDecoration(
//                        border: Border.all(
//                          color: Color(0x000100FF),
//                          width: 1.0,
//                        ),
//                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                      ),
//                      child: FormButton(
//                          buttonTextSize: 24,
//                          name: "Login",
//                          onPressed: widget.onPressedLogin)))
            ]),
      ),
    );
  }

  Widget _showPageData(OnboardingModel page) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image(
                image: AssetImage(page.imagePath),
                height: 200.69,
                width: 200.69),
          ),
          Center(
            child: Text(
              page.title,
              style: TextStyle(
                color: Color(0xff0000ff),
                fontSize: 24,
                fontFamily: "Gilroy-Bold",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Center(
            child: SizedBox(
              width: 329,
              height: 50,
              child: Text(
                page.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: page.descripColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
