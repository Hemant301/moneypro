import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Apis.dart';

class UpdatePopup extends StatelessWidget {
  final String major;

  const UpdatePopup({Key? key, required this.major}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            appLogo(),
            SizedBox(
              height: 10,
            ),
            Text(
              "New Version Released",
              style: TextStyle(
                  color: green, fontSize: font20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2,
            ),
            Container(
              height: 2,
              width: 50,
              color: orange,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Image.asset('assets/app_update_icon1.png'),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "App update require",
              style: TextStyle(
                  color: red, fontSize: font16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Get hassel FREE and BUG free App.",
              style: TextStyle(
                  color: black, fontSize: font16, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            _launchURL();
            SystemNavigator.pop();
          },
          child: Wrap(
            children: [
              (major.toString() == "2")
                  ? Container()
                  : InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          "SKIP",
                          style: TextStyle(
                              color: black,
                              fontSize: font16,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    "UPDATE NOW",
                    style: TextStyle(fontSize: font16, color: white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL() async => await canLaunch(appUrl)
      ? await launch(appUrl)
      : throw 'Could not launch $appUrl';
}

Widget backArrow() {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Image.asset(
        'assets/back_arrow.png',
      ),
    ),
  );
}

Widget appLogo() {
  return Image.asset(
    'assets/app_splash_logo.png',
    width: 120,
  );
}

Widget circularProgressLoading(height) {
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: SizedBox(
      height: height,
      width: height,
      child: Center(
        child: CircularProgressIndicator(
          color: lightBlue,
        ),
      ),
    ),
  );
}

class CustomAppDialog extends StatelessWidget {
  final String message;
  const CustomAppDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            margin: EdgeInsets.only(top: 20, left: 0, right: 0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                      child: Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: CircularProgressIndicator(
                                color: lightBlue,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Image.asset(
                                'assets/appM_logo.png',
                                height: 40,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30, bottom: 30),
                      child: Center(
                          child: Text(
                        "$message",
                        style: TextStyle(color: black, fontSize: font14),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ],
                ))),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  RoundedButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: white,
            border: Border.all(color: gray)),
        alignment: Alignment.center,
        child: Text(
          '$title',
          style: TextStyle(fontSize: 20, color: lightBlue),
        ),
      ),
    );
  }
}

class setPinAlert extends StatelessWidget {
  final String pin;

  const setPinAlert({Key? key, required this.pin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Wrap(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  margin: EdgeInsets.only(top: 20, left: 0, right: 0),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Image.asset(
                            'assets/pin_alert.png',
                            height: 64,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            success,
                            style: TextStyle(
                                color: green,
                                fontSize: font18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 25),
                            child: Text(
                              pinMsg,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: black,
                                  fontSize: font14,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              savePIN(pin.toString());
                              closeParticularPage(context, "SignUp");
                              closeCurrentPage(context);
                              saveUserLogin(true);
                              openPerspective(context, true);
                            },
                            child: Text(
                              ok,
                              style:
                                  TextStyle(color: lightBlue, fontSize: font15),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ))),
            ),
          )
        ],
      ),
    );
  }
}

Widget indicatorsTop(controller, count) {
  return SmoothPageIndicator(
      controller: controller, // PageController
      count: count,
      effect: WormEffect(
          spacing: 3.0,
          dotHeight: 8.0,
          dotWidth: 8.0,
          activeDotColor: dotColor), // your preferred effect
      onDotClicked: (index) {});
}

Widget indicatorsMerchant(controller, count) {
  return SmoothPageIndicator(
      controller: controller, // PageController
      count: count,
      effect: WormEffect(
          spacing: 10.0,
          dotHeight: 8.0,
          dotWidth: 8.0,
          activeDotColor: lightBlue), // your preferred effect
      onDotClicked: (index) {});
}

void _launchURL() async => await canLaunch(appUrl)
    ? await launch(appUrl)
    : throw 'Could not launch $appUrl';

AppBar appBarHome(context, icon, width) {
  return AppBar(
    elevation: 0,
    centerTitle: false,
    backgroundColor: white,
    brightness: Brightness.light,
    leading: InkWell(
      onTap: () {
        closeKeyBoard(context);
        closeCurrentPage(context);
      },
      child: Container(
        height: 60,
        width: 60,
        child: Stack(
          children: [
            Image.asset(
              'assets/back_arrow_bg.png',
              height: 60,
            ),
            Positioned(
              top: 16,
              left: 12,
              child: Image.asset(
                'assets/back_arrow.png',
                height: 16,
              ),
            )
          ],
        ),
      ),
    ),
    titleSpacing: 0,
    title: appLogo(),
    actions: [
      (icon.toString() == "")
          ? Container()
          : Image.asset(
              '$icon',
              width: width,
            ),
      SizedBox(
        width: 10,
      )
    ],
  );
}

class NoDataFound extends StatelessWidget {
  final String text;

  const NoDataFound({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('assets/no_data.png'),
            ),
            Text(
              text,
              style: TextStyle(color: black, fontSize: font16),
            ),
          ],
        ),
      ),
    );
  }
}

Widget appSelectedBanner(context, banner, height) {
  return Card(
    margin: EdgeInsets.only(left: 10, right: 10, top: 8),
    elevation: 10,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset(
          "assets/$banner",
          fit: BoxFit.fill,
        ),
      ),
    ),
  );
}

class exitProcess extends StatelessWidget {
  const exitProcess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: padding,
              top: avatarRadius + padding,
              right: padding,
              bottom: padding),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Action Incomplete",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "$exitMsg",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 18),
                      )),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        removeAllPages(context);
                      },
                      child: Text(
                        "Exit",
                        style: TextStyle(fontSize: 18),
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: Image.asset("assets/stop.png")),
          ),
        ),
      ],
    );
  }
}

class NoExitDialog extends StatelessWidget {
  const NoExitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: padding,
              top: avatarRadius + padding,
              right: padding,
              bottom: padding),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Action Incomplete",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "$noExit",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 18),
                      )),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        SystemNavigator.pop();
                      },
                      child: Text(
                        "Exit",
                        style: TextStyle(fontSize: 18),
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: Image.asset("assets/stop.png")),
          ),
        ),
      ],
    );
  }
}

class CustomInfoDialog extends StatelessWidget {
  final String title, description, buttonText;

  CustomInfoDialog({
    required this.title,
    required this.description,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 66 + 16,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          margin: EdgeInsets.only(top: 66),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 10.0,
                offset: const Offset(0.0, 0.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          child: CircleAvatar(
            radius: 66,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: Image.asset("assets/stop.png")),
          ),
        ),
      ],
    );
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 5;

  @override
  double get iconSize => 20;

  @override
  TextStyle textStyle(Color color) {
    return TextStyle(fontSize: 13, color: color);
  }
}

class KycThankYouDialog extends StatelessWidget {
  final String message;

  const KycThankYouDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
              left: padding,
              top: avatarRadius + padding,
              right: padding,
              bottom: padding),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Info",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "$message",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      removeAllPages(context);
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: Image.asset("assets/pin_alert.png")),
          ),
        ),
      ],
    );
  }
}

class ThankYouDialog extends StatelessWidget {
  final String text;
  final String isCloseAll;

  const ThankYouDialog({Key? key, required this.text, this.isCloseAll = "0"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      padding: EdgeInsets.only(left: 0, top: 20 + 0, right: 0, bottom: 0),
      margin: EdgeInsets.only(top: avatarRadius),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(padding),
          boxShadow: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            "assets/thanks.png",
            height: 100,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Thank you",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  if (isCloseAll == "1") {
                    removeAllPages(context);
                  } else if (isCloseAll == "0") {
                    closeCurrentPage(context);
                  } else if (isCloseAll == "3") {
                    // for money transfer screen
                    removeAllPages(context);
                    openMoneyTransferLanding(context);
                  }
                },
                child: Text(
                  "Ok",
                  style: TextStyle(fontSize: 18),
                )),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}

class PANkycDialog extends StatelessWidget {
  final String text;

  const PANkycDialog({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
              left: padding,
              top: avatarRadius + padding,
              right: padding,
              bottom: padding),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Info",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "We have sent link to your registered mail id: $text",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: Image.asset("assets/pin_alert.png")),
          ),
        ),
      ],
    );
  }
}

class MyBlinkingButton extends StatefulWidget {
  @override
  _MyBlinkingButtonState createState() => _MyBlinkingButtonState();
}

class _MyBlinkingButtonState extends State<MyBlinkingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: EdgeInsets.all(4.0),
        child: Text(
          "Top Ups",
          style: TextStyle(color: black, fontSize: font12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class CustomAEPSInfoDialog extends StatelessWidget {
  final String title, description;

  CustomAEPSInfoDialog({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          SizedBox(height: 16.0),
          circularProgressLoading(40.0),
          SizedBox(height: 16.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 24.0),
        ],
      ),
    );
  }
}

class showMessageDialog extends StatelessWidget {
  final String message;
  final int action;

  const showMessageDialog(
      {Key? key, required this.message, required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: padding,
              top: avatarRadius + padding,
              right: padding,
              bottom: padding),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Text(
                "$message",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      if (action == 1) {
                        // reopen team member list
                        openTeamMemberList(context);
                      } else if (action == 2) {
                        removeAllPages(context);
                        openInvestorLanding(context);
                      } else if (action == 3) {
                        removeAllPages(context);
                      } else if (action == 4) {
                        removeAllPages(context);
                        openInvestorLanding(context);
                      }else if (action == 5){
                        closeCurrentPage(context);
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 0),
                      decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          border: Border.all(color: lightBlue)),
                      child: Center(
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: white),
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: Image.asset("assets/pin_alert.png")),
          ),
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class showMerchantKycByEmp extends StatelessWidget {
  final String text;
  final String token;
  final String name;
  final String mobile;
  final String companyName;
  final String qrDisplayName;

  const showMerchantKycByEmp(
      {Key? key,
      required this.text,
      required this.token,
      required this.name,
      required this.mobile,
      required this.companyName,
      required this.qrDisplayName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      margin: EdgeInsets.only(top: avatarRadius),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(padding),
          boxShadow: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Image.asset(
            "assets/thanks.png",
            height: 60,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Thank you",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
                openMerchantQRWMsg(
                    context, token, name, mobile, companyName, qrDisplayName);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .4,
                margin: EdgeInsets.only(left: 20, right: 10),
                decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: white,
                    )),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Ok",
                      style: TextStyle(fontSize: 18, color: white),
                    ),
                  ),
                ),
              )),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}