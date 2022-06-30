import 'package:flutter/material.dart';
import 'package:moneypro_new/ui/home/Perspective.dart';
import 'package:moneypro_new/utils/Constants.dart';

class Receivedscreen extends StatefulWidget {
  const Receivedscreen({Key? key}) : super(key: key);

  @override
  State<Receivedscreen> createState() => _ReceivedscreenState();
}

class _ReceivedscreenState extends State<Receivedscreen> {
  Future<bool> _onback() {
    return check();
  }

  check() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Perspective(isShowWelcome: false),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    print(data['amount']);

    String newdata = data['amount'].substring(1);
    print('$newdata newdata amount');

    String realamount = newdata.substring(0, newdata.length - 1);
    print('$realamount real amount');
    return WillPopScope(
      onWillPop: _onback,
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Container(
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: Center(
                child: Column(
              children: [
                Image.asset(
                  'assets/app_splash_logo.png',
                  height: 30,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '$rupeeSymbol ${realamount}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
