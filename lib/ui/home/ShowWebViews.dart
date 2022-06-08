import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:webview_flutter/webview_flutter.dart';


class ShowWebViews extends StatefulWidget {
  final String url;

  const ShowWebViews({Key? key, required this.url}) : super(key: key);

  @override
  _ShowWebViewsState createState() => _ShowWebViewsState();
}

class _ShowWebViewsState extends State<ShowWebViews> {
  var isLoading = true;

  final _key = UniqueKey();

  var className = "Web views";

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: white,
            appBar: appBarHome(
              context,
              "",
              24.0,
            ),
            body: Stack(
              children: [
                WebView(
                  key: _key,
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  javascriptChannels: [
                    JavascriptChannel(
                        name: 'backtoapp',
                        onMessageReceived: (message) {
                          print('message from webview  ${message.message}');
                        })
                  ].toSet(),
                  onPageFinished: (String url) {
                    setState(() {
                      print('Page finished loading: $url');
                      isLoading = false;
                    });
                  },
                ),
                isLoading
                    ? Center(child: circularProgressLoading( 40.0))
                    : Container(),
              ],
            )));
  }
}
