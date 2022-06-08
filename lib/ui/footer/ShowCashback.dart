import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:scratcher/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class ShowCashback extends StatefulWidget {
  final String commission;
  final String id;

  const ShowCashback({Key? key, required this.commission, required this.id}) : super(key: key);

  @override
  _ShowCashbackState createState() => _ShowCashbackState();
}

class _ShowCashbackState extends State<ShowCashback>
    with SingleTickerProviderStateMixin {

  var screen = "Show Cashback";

  double _opacity = 0.0;

  late AnimationController controller;
  late Animation colorAnimation;
  late Animation sizeAnimation;

  final scratchKey = GlobalKey<ScratcherState>();

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    controller.addListener(() {
      setState(() {});
    });

    colorAnimation =
        ColorTween(begin: Colors.blue, end: Colors.yellow).animate(controller);
    sizeAnimation = Tween<double>(begin: 100.0, end: 200.0).animate(controller);

    //controller.forward();

    // Repeat the animation after finish
    controller.repeat();


  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        printMessage(screen, "Mobile back pressed");
        if(widget.id!=""){
          removeAllPages(context);
          openRewardsList(context);
        }
        return true;
      },
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Wrap(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width *.8,
                  decoration: BoxDecoration(
                      color:white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Scratcher(
                     // color: lightBlue,
                      key: scratchKey,
                      accuracy: ScratchAccuracy.low,
                      threshold: 40,
                      brushSize: 40,
                      onThreshold: () {
                        setState(() {
                          _opacity = 1;
                          scratchKey.currentState?.reveal(duration: Duration(milliseconds: 200));
                        });
                        if(widget.id!=""){
                          changeStickerStatus(widget.id.toString());
                        }
                      },
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 100),
                        opacity: _opacity,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                              ),
                              border: Border.all(color: white)),
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Congrats You Won!",
                                      style: TextStyle(
                                          color: orange,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "$rupeeSymbol ${widget.commission}",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.asset(
                                      'assets/giftbox.png',
                                      height: 120,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Cashback",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: font18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 90,
                                left: 20,
                                child: Image.asset('assets/fivestar.png'),
                                height: sizeAnimation.value * .20,
                                width: sizeAnimation.value * .20,
                              ),
                              Positioned(
                                  right: 60,
                                  top: 50,
                                  child: Image.asset(
                                    'assets/fivestar.png',
                                    height: sizeAnimation.value * .18,
                                    width: sizeAnimation.value * .18,
                                  )),
                              Positioned(
                                  top: 90,
                                  right: 20,
                                  child: Image.asset(
                                    'assets/onestar.png',
                                    height: sizeAnimation.value * .12,
                                    width: sizeAnimation.value * .12,
                                  )),
                              Positioned(
                                  bottom: 20,
                                  right: 50,
                                  child: Image.asset(
                                    'assets/onestar.png',
                                    height: sizeAnimation.value * .14,
                                    width: sizeAnimation.value * .14,
                                  )),
                              Positioned(
                                  top: 70,
                                  left: 50,
                                  child: Image.asset(
                                    'assets/onestar.png',
                                    height: sizeAnimation.value * .15,
                                    width: sizeAnimation.value * .15,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      image: Image.asset('assets/scratchBanner.png',),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
  Future changeStickerStatus(txId) async {


    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "$token",
      "txn_id": "$txId",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(scratchStatusUpdateAPI),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Wallet Transaction : $data");

    setState(() {
    });
  }
}
