import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class MATMProcess extends StatefulWidget {
  const MATMProcess({Key? key}) : super(key: key);

  @override
  _MATMProcessState createState() => _MATMProcessState();
}

class _MATMProcessState extends State<MATMProcess> {

  var screen = "MATM Process";

  var loading = false;

  @override
  void initState() {
    super.initState();
    getMATMTxnId();
  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>Scaffold(
      backgroundColor: white,
      appBar: appBarHome(
        context,
        "",
        24.0.w,
      ),
      body: (loading)
          ? Center(
        child: circularProgressLoading(40.0),
      )
          : Container(),
    ));
  }

  Future getMATMTxnId() async {
    setState(() {
      loading = true;
    });

    var userToken = await getToken();
    var mId = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    var body = {"user_token": "$userToken", "m_id": "$mId"};

    printMessage(screen, "Body : $body");

    final response = await http.post(Uri.parse(matmAppTxnStatusAPI),
        headers: headers, body: jsonEncode(body));

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Update Response : $data");

      setState(() {
        loading = false;
        if (data['status'].toString() == "1") {
          var aepsTxnId = data['txn_id'].toString();
          getATMAuthToken(aepsTxnId);
        }
      });
    }else{
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }


  }

  Future getATMAuthToken(aepsTxnId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var header = {
      "secretKey": "$atmSecrettKey",
      "saltKey": "$atmSaltKey",
      "encryptdecryptKey": "$atmEncDecKey"
    };

    final response = await http.post(Uri.parse(authUrl), headers: header);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "MATM Response : $data");

    setState(() {
      Navigator.pop(context);
      if (data['isSuccess'].toString() == "true") {
        var authToken = data['data']['token'].toString();
        printMessage(screen, "Auth Token : $authToken");
        checkKycStatus(authToken, aepsTxnId);
      } else {
        showToastMessage("Something went wrong. Please after sometime");
      }
    });
  }

  Future checkKycStatus(authToken, aepsTxnId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, checking your KYC status");
          });
    });

    var mId = await getMATMMerchantId();
    var email = await getEmail();
    var mobile = await getMobile();

    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {
        "merchant_id": "$mId",
        "emailId": "$email",
        "mobileNo": "$mobile"
      };

      String result = await platform.invokeMethod("kycStatus", arr);

      printMessage(screen, "Submit json : $result");

      var header = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };

      final response = await http.post(Uri.parse(merchantStatusKYC),
          headers: header,
          body: (result),
          encoding: Encoding.getByName("utf-8"));

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Status Data : $data");

      setState(() {
        Navigator.pop(context);

        var isSuccess = data['isSuccess'].toString();

        if (isSuccess.toString() == "true") {
          var sta = data['data']['statusDescription'].toString();

          var statusCode = data['data']['statusCode'].toString();

          // PK = Pending For KYC
          // A = Active
          // R = Rejected
          // D = Deactive

          if (statusCode == "A") {
            _moveToMATM(authToken, aepsTxnId);
          } else if (statusCode == "PK") {
            Navigator.of(context).pop();
            _moveToMATM(authToken, aepsTxnId);
          } else if (statusCode == "R") {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ThankYouDialog(
                    text: "$sta",
                    isCloseAll: "2".toString(),
                  );
                });
          } else if (statusCode == "D") {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ThankYouDialog(
                    text: "$sta",
                    isCloseAll: "2".toString(),
                  );
                });
          }
        } else {
          Navigator.pop(context);
          showToastMessage(data['message'].toString());
          openATMOnBoarding(context);
        }
      });
    }
  }

  _moveToMATM(authToken, aepsTxnId) async {

    String result = "";
    var merchantId = await getMATMMerchantId();
    var merchantEmailId = await getEmail();
    var merchantMobileNo = await getMobile();

    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {
        "merchantId": "$merchantId",
        "merchantEmailId": "$merchantEmailId",
        "merchantMobileNo": "$merchantMobileNo",
        "token": "$authToken",
        "enryptdecryptKey": "$atmEncDecKey",
        "pipe": "ICICI",
        "partnerRefId": "$aepsTxnId"
      };

      printMessage(screen, "Calling SKD : $arr");
      result = await platform.invokeMethod("moveATM", arr);
    }

    printMessage(screen, "Reg : $result");
    _setMATMResults(result, aepsTxnId);
  }

  _setMATMResults(result, aepsTxnId) {
   try{
     var json = jsonDecode(result);

     var message = json['message'];
     var sts = json['statusCode'];

     printMessage(screen, "MATM STATUS CODE : $sts");
     printMessage(screen, "MATM MESSAGE: $message");

     if (message.toString() == "Success") {
       var txnType = json['txnType'];

       printMessage(screen, "Tans Type : $txnType");

       var amount = json['transactionAmount'].toString();
       var balanceAmount = json['balanceAmount'].toString();
       var cardNo = json['cardNo'].toString();
       var terminalId = json['terminalId'].toString();
       var txnDate = json['txnDate'].toString();
       var txnId = json['txnId'].toString();
       var bankName = json['bankName'].toString();
       var partnerRefId = json['partnerRefId'].toString();
       var merchantMobileNo = json['merchantMobileNo'].toString();
       var cardType = json['cardType'].toString();
       var rrn = json['rrn'].toString();
       var bankMessage= json['bankMessage'].toString();

       Map p = {
         "message": "Transaction Success",
         "date": "$txnDate",
         "bankName": "$bankName",
         "cardNo": "$cardNo",
         "cardType": "$cardType",
         "txnType": "$txnType",
         "amount": "$amount",
         "refId": "$partnerRefId",
         "transId": "$txnId",
         "terminalId": "$terminalId",
         "mobile": "$merchantMobileNo",
         "balanceAmount": "$balanceAmount",
         "rrn": "$rrn",
         "txnid": "$aepsTxnId",
         "removeAll":"Yes",
         "txnStatus":"$message",
         "bankMessage":"$bankMessage"
       };
       openTransactionRecpit(context, p);
     } else {
       if (sts.toString() != "1008" ) {
         printMessage(screen, "*******INSIDE********");

         var amount = json['transactionAmount'];
         var cardNo = json['cardNo'];
         var cardType = json['cardType'];
         var txnDate = json['txnDate'];
         var bankName = json['bankName'];
         var txnType = json['txnType'];
         var rrn = json['rrn'];
         var terminalId = json['terminalId'];
         var partnerRefId = json['partnerRefId'];
         var merchantMobileNo = json['merchantMobileNo'];
         var txnId = json['txnId'].toString();
         var bankMessage= json['bankMessage'].toString();
         var txnStatus= json['txnStatus'].toString();

         Map p = {
           "message": "Transaction $message",
           "date": "$txnDate",
           "bankName": "$bankName",
           "cardNo": "$cardNo",
           "cardType": "$cardType",
           "txnType": "$txnType",
           "amount": "$amount",
           "refId": "$partnerRefId",
           "transId": "$txnId",
           "terminalId": "$terminalId",
           "mobile": "$merchantMobileNo",
           "balanceAmount": "",
           "rrn": "$rrn",
           "txnid": "$aepsTxnId",
           "removeAll":"Yes",
           "txnStatus":"$txnStatus",
           "bankMessage":"$bankMessage"
         };
         if(message.toString()!="Back key press"){
           openTransactionRecpit(context, p);
         }else{
           closeCurrentPage(context);
         }

       }else{
         closeCurrentPage(context);
       }
       showToastMessage(message);
     }
   }catch(e){
     closeCurrentPage(context);
     printMessage(screen, "Error : ${e.toString()}");
   }
  }
}
