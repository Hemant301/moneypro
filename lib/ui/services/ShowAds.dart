import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ShowAds extends StatefulWidget {
  final String logo;
  final String location;
  final String role;
  final String kycStatus;

  const ShowAds(
      {Key? key,
      required this.logo,
      required this.location,
      required this.role,
      required this.kycStatus})
      : super(key: key);

  @override
  _ShowAdsState createState() => _ShowAdsState();
}

class _ShowAdsState extends State<ShowAds> {
  var screen = "Show Ads";

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
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: InkWell(
              onTap: () async {
                printMessage(screen, "Clicked location : ${widget.location}");
                printMessage(screen, "Clicked logo : ${widget.logo}");
                printMessage(screen, "Clicked role : ${widget.role}");

                if (widget.location.toString().toLowerCase() == "recharge") {
                  openMobileSelection(context, "");
                } else if (widget.location.toString().toLowerCase() ==
                        "myinvest" ||
                    widget.location.toString().toLowerCase() == "my invest") {
                  if (widget.role == "3") {
                    var dob = await getDOB();
                    if (isAdult(dob)) {
                      getInvestorKycStatus();
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomInfoDialog(
                          title: "Alert",
                          description:
                              "To became Investor, your age must be above or equal to 18 years.",
                          buttonText: "Okay",
                        ),
                      );
                    }
                  } else {
                    getInvestorKycStatus();
                  }
                } else if (widget.location.toString().toLowerCase() ==
                        "upi qr" ||
                    widget.location.toString().toLowerCase() == "upiqr") {
                  if (widget.kycStatus.toString() == "1" &&
                      widget.role == "3") {
                    openViewQRCode(context, 0);
                  } else {
                    openBecameMerchant(context);
                  }
                } else if (widget.location.toString().toLowerCase() ==
                        "fast tag" ||
                    widget.location.toString().toLowerCase() == "fasttag") {
                  openRechargeSelection(context, "FASTAG", "Bank", "Bank");
                }
              },
              child: Image.network("$adsBaseUrl${widget.logo}")),
        ),
        Positioned(
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.highlight_remove_rounded)),
          right: 5,
          top: 5,
        )
      ],
    );
  }

  bool isAdult(String birthDateString) {
    String datePattern = "dd-MM-yyyy";

    // Current time - at this moment
    DateTime today = DateTime.now();

    // Parsed date to check
    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);

    // Date to check but moved 18 years ahead
    DateTime adultDate = DateTime(
      birthDate.year + 18,
      birthDate.month,
      birthDate.day,
    );
    return adultDate.isBefore(today);
  }

  Future getInvestorKycStatus() async {
    setState(() {});

    var mobile = await getMobile();
    var pan = await getPANNo();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "mobile": mobile,
    };

    printMessage(screen, "investor body : $body");

    final response = await http.post(Uri.parse(investorKycStatusAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Investor : ${data}");

      setState(() {
        var statusCode = response.statusCode;
        if (statusCode == 200) {
          if (data['status'].toString() == "1") {
            if (data['profile_data']['account_no'].toString() == "" ||
                data['profile_data']['account_no'].toString() == "null") {
              openInvestorBankDetail(context, pan);
            } else {
              openInvestorLanding(context);
            }
          } else if (data['status'].toString() == "3") {
            openInvestorDocument(context, pan);
          } else if (data['status'].toString() == "2") {
            openInvestorOnboarding(context);
          } else {
            showToastMessage(data['message'].toString());
          }
        }
      });
    } else {
      setState(() {});
      showToastMessage(status500);
    }
  }
}
